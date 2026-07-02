# AGENTS.md

NixOS system flake. `flake-parts` + [dendritic pattern](https://github.com/mightyiam/dendritic): every `*.nix` under `modules/` is a **top-level flake-parts module**, not a NixOS/home-manager module.

## Architecture

- `flake.nix`: inputs → `flake-parts.lib.mkFlake { imports = [./modules]; }`.
- `modules/default.nix`: auto-imports every `*.nix` under `modules/` (recursive, except `default.nix`) via `lib.fileset`. No import lists. File paths carry no meaning. **`git add` new files** — flakes only see tracked files.
- Each file declares flake attrs. Plain NixOS/home-manager module without one = silently does nothing:

  | Attribute | Purpose |
  |---|---|
  | `flake.modules.nixos.<name>` | NixOS module (consumed by `configurations.nix`) |
  | `flake.modules.homeManager.<name>` | home-manager module |
  | `flake.nixos.configurations.<host>` | Host definition |
  | `flake.users.<name>` | User spec |
  | `flake.persistence` | Cross-module persistence declarations (consumed by `impermanence.nix`) |

### Module types

- **`default`** (merge into `flake.modules.nixos.default` / `homeManager.default`, apply to all): `nixos.nix`, `cache.nix`, `determinate.nix`, `security.nix`, `ssh.nix`, `xdg.nix` (nixos); `git.nix`, `xdg.nix` (home-manager). Prefer merging into `default` over new module names.
- **Opt-in** (imported explicitly by hosts/users):
  - `boot.nix` → `flake.modules.nixos.boot`: systemd-boot + `efi.canTouchEfiVariables`.
  - `secureboot.nix` → `flake.modules.nixos.secureboot`: UEFI Secure Boot via [Lanzaboote](https://github.com/nix-community/lanzaboote). Disables `systemd-boot.enable` (`mkForce false`), wraps systemd-boot with signed UKIs. Auto-generates + auto-enrolls keys on first boot (requires firmware Setup Mode). Persists `/var/lib/sbctl` via `flake.persistence`.
  - `btrfs.nix` → `flake.modules.nixos.btrfs`: BTRFS rollback for ephemeral root.
  - `graphics.nix`, `wsl.nix`, `networking/` (`dns.nix`, `networkmanager.nix`).
  - `agent.nix`, `zed.nix` (home-manager).

### Key evaluators

- **`configurations.nix`**: NixOS evaluator. Each `flake.nixos.configurations.<name>` → `withSystem` → `nixpkgs.lib.nixosSystem`. Always imports `default` + host `module` + `flake.modules.nixos.<name>` if exists (hostname match, e.g. `disko.nix`). Pins `system.stateVersion = "26.05"`, sets `networking.hostName`.
- **`users.nix`**: `flake.users.<name>` → `flake.modules.nixos.user-<name>`. Creates user, wires `home-manager.users.<name>` to `homeManager.default` + `home-manager` + optional per-user `homeManager.<name>`. Exposes `userMeta` (read by `git.nix`).
- **`home-manager.nix`**: imports home-manager nixosModule; derives `home.stateVersion` from `osConfig.system.stateVersion`. Pulled in by `users.nix` for every user.
- **`impermanence.nix`**: wraps `inputs.impermanence` for `/persist`-based root. Defines `flake.persistence` option (`nixos.directories`, `homeManager.directories`) so other modules declare what to persist. Auto-imported when `ephemeral = true`. BTRFS rollback (`btrfs`) is **separate** — host imports explicitly.
- **`modules/parts/`**: flake-level wiring — systems, perSystem pkgs (overlays + `allowUnfree`), alejandra formatter.

## Hosts

| Host | System | Ephemeral | Notes |
|---|---|---|---|
| `cinnamon` | x86_64-linux | yes | Baremetal. disko LUKS + BTRFS (`root`/`nix`/`persist`). boot + btrfs + secureboot. |
| `paprika` | x86_64-linux | no | NixOS-WSL + graphics. |

## Inputs

- `nixpkgs` (unstable), `nixpkgs-stable` (nixos-26.05). Stable via `pkgs.stable.<pkg>` overlay.
- `lanzaboote`: Secure Boot. `inputs.nixpkgs.follows = "nixpkgs"`.
- `home-manager`, `impermanence`, `disko`, `determinate`, `nixos-wsl`, `nix-cachyos-kernel`, `llm-agents`.
- Use `perSystem` `pkgs`, never raw `nixpkgs.legacyPackages`.
- Keep new inputs `follows = "nixpkgs"` unless version split intentional.
- `home.stateVersion` derived from `osConfig.system.stateVersion` — never set per-user.

## Commands

| Command | Purpose |
|---|---|
| `nix fmt` | Format (alejandra) |
| `nix flake check` | Build every toplevel (**expensive**, not a lint) |
| `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` | Build without switching |
| `nixos-rebuild switch --flake .#<host>` | Apply |
| `nix flake update [<input>]` | Update lockfile |

## Environment

- **Determinate Nix** — no vanilla nix installer/upgrade commands.
- `pipe-operators` experimental feature enabled — `|>` used throughout.
- Systems: `x86_64-linux`, `aarch64-linux`.
- Conventional Commits (`feat:`/`fix:`/`refactor:`); default branch `main`.

## Conventions

- **Add host**: `modules/hosts/<name>/configuration.nix`:
  ```nix
  flake.nixos.configurations.<name> = { system; ephemeral ? false; module = {...}; };
  ```
  Optional `modules/hosts/<name>/disko.nix` → `flake.modules.nixos.<name>` (auto-imported by hostname match).
- **Add user**: `modules/users/<name>.nix`:
  ```nix
  flake.users.<name> = { email; sudo; groups; module; };
  ```
  Optional `flake.modules.homeManager.<name>` for per-user home-manager config.
- **Declare persistence**: set `flake.persistence.nixos.directories` or `flake.persistence.homeManager.directories.<user>` from any module. Consumed by `impermanence.nix` on ephemeral hosts.
