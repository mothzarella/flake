# AGENTS.md

NixOS system flake built on `flake-parts` and the
[dendritic pattern](https://github.com/mightyiam/dendritic): every file under
`modules/` is a **top-level flake-parts module**, not a NixOS/home-manager
module.

## Architecture

- `flake.nix` only declares inputs and hands off to
  `flake-parts.lib.mkFlake { inherit inputs; } { imports = [./modules]; }`.
- `modules/default.nix` auto-imports **every** `*.nix` file under `modules/`
  (recursively) except `default.nix`, via `lib.fileset`. Do **not** maintain
  import lists — dropping a new `.nix` file anywhere under `modules/` is
  enough; file paths carry no meaning and can be renamed/moved freely.
- Each file declares top-level flake attrs that lower-level evaluators consume:
  - `flake.modules.nixos.<name>` — NixOS module (consumed by `modules/configurations.nix`).
  - `flake.modules.homeManager.<name>` — home-manager module.
  - `nixos.configurations.<host>` — a host (see `modules/hosts/`).
  - `users.<name>` — a user spec (see `modules/users/`).
  Writing a plain NixOS/home-manager module without one of these attrs silently
  does nothing.
- `modules/configurations.nix` is the top-level NixOS evaluator: for each
  `nixos.configurations.<name>` it calls `withSystem` then
  `nixpkgs.lib.nixosSystem`, always importing `flake.modules.nixos.default` plus
  the host's `module`, and `flake.modules.nixos.<name>` if it exists. It pins
  `system.stateVersion = "26.05"` and sets `networking.hostName = name`.
- Several files merge into the shared `flake.modules.nixos.default`
  (`nixos.nix`, `cache.nix`, `determinate.nix`, `security.nix`, `xdg.nix`)
  and `flake.modules.homeManager.default` (`git.nix`, `xdg.nix`,
  `security.nix`, plus the aggregator in `home-manager.nix` which imports
  `home-manager`, `zed`, `agent`).
  Prefer merging cross-cutting settings into `default` over inventing a new
  module name per concern (dendritic guidance: avoid lower-level name
  proliferation).
- `modules/users.nix` turns each `users.<name>` into
  `flake.modules.nixos.user-<name>` (system user + `home-manager.users.<name>`
  wired to `flake.modules.homeManager.default`, plus a per-user
  `flake.modules.homeManager.<name>` if present) and exposes a `userMeta`
  option read by `modules/git.nix`.
- `modules/parts/` holds flake-level wiring: `systems.nix` (systems list +
  `perSystem` `pkgs` re-imported with the flake overlay and
  `allowUnfree = true` + `alejandra` formatter), `overlays.nix` (default
  overlay: `llm-agents`, `nix-cachyos-kernel`, and `stable` from
  `nixpkgs-stable`), `flake.nix` (imports `flake-parts`/`home-manager`
  flakeModules).

## Inputs & flake-parts conventions

- Two nixpkgs: `nixpkgs` (unstable) and `nixpkgs-stable` (nixos-26.05). Access
  stable packages as `pkgs.stable.<pkg>` via the overlay; use `perSystem`
  `pkgs`, not raw `nixpkgs.legacyPackages`.
- Follow flake-parts best practices: make no assumption about which `inputs`
  are present, never traverse/recurses into `inputs` (triggers fetches and is
  fragile), put build/test work in `perSystem`, and namespace option names
  (no overly general names like `programs` at top level).
- `inputs.nixpkgs.follows` is used by `home-manager`; keep new inputs aligned
  with `nixpkgs` unless a version split is intentional.

## Commands

- Format: `nix fmt` (alejandra, set in `modules/parts/systems.nix`). This is
  the only formatter — there is no treefmt, pre-commit, justfile, or direnv.
- Verify the flake: `nix flake check` — builds every `nixosConfigurations.*`
  toplevel as a check (`configurations:nixos:<host>`), so it is **expensive**
  (full system build), not a cheap lint.
- Build a host without switching:
  `nix build .#nixosConfigurations.paprika.config.system.build.toplevel`
- Apply a host: `nixos-rebuild switch --flake .#paprika`
- Update lockfile: `nix flake update` (single input: `nix flake update <input>`).

## Environment

- Nix is **Determinate Nix** (`nix --version` shows "Determinate Nix";
  `modules/determinate.nix` imports the determinate nixosModule). Do not use
  vanilla nix installer/upgrade commands.
- `pipe-operators` experimental feature is enabled in `nixos.nix` and used
  throughout (e.g. `modules/default.nix`, `modules/configurations.nix` use `|>`).
  The dev Nix must support `|>` (Determinate Nix 2.34+ does).
- Supported systems: `x86_64-linux`, `aarch64-linux`. Only host currently:
  `paprika` (WSL, x86_64-linux).
- `home.stateVersion` is derived from `osConfig.system.stateVersion` in
  `modules/home-manager.nix` — do not set it per-user.

## Conventions

- Conventional Commits (`feat:`, `fix:`, `refactor:`); default branch `main`.
- Add a host: create `modules/hosts/<name>.nix` setting
  `nixos.configurations.<name> = { system; module = {...}; };`.
- Add a user: create `modules/users/<name>.nix` setting
  `users.<name> = { email; sudo; groups; module; };` and optionally
  `flake.modules.homeManager.<name>`.
