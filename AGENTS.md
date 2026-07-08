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

- **`default`** (merge into `flake.modules.nixos.default` / `homeManager.default`, apply to all): `nixos.nix`, `cache.nix`, `determinate.nix`, `security/` (`audit.nix`, `keyring.nix`, `polkit.nix`), `ssh.nix`, `xdg.nix`, `chaotic.nix`, `secrets.nix` (nixos); `git.nix`, `xdg.nix`, `secrets.nix` (home-manager). Prefer merging into `default` over new module names.
- **Opt-in** (imported explicitly by hosts/users):
  - `boot.nix` → systemd-boot + `efi.canTouchEfiVariables`.
  - `secureboot.nix` → UEFI Secure Boot via [Lanzaboote](https://github.com/nix-community/lanzaboote): wraps systemd-boot with signed UKIs (`systemd-boot.enable = mkForce false`), auto-generates + auto-enrolls keys on first boot (requires firmware Setup Mode). Persists `/var/lib/sbctl`.
  - `btrfs.nix` → initrd rollback for ephemeral root. Mounts `cryptroot` top-level (`subvol=/`), moves `root` subvolume to `old_roots/<timestamp>`, prunes entries >30 days, creates fresh empty `root` (NixOS repopulates `/` from `/nix` closure). Self-contained — no `root-blank` prerequisite. Requires LUKS mapper `cryptroot` (host `disko.nix`); `subvol=root` mount expected on `/`.
  - `graphics.nix`, `wsl.nix`, `networking/` (`dns.nix`, `networkmanager.nix`, `iwd.nix`, `mullvad.nix`); `agent.nix`, `zed.nix`, `firefox.nix` (home-manager). `firefox.nix` hardens privacy (strict content blocking, HTTPS-only, telemetry/Pocket/studies disabled) and force-installs uBlock Origin + the Mullvad Browser Extension via `programs.firefox.policies.ExtensionSettings`.
- **`gaming`** (imported explicitly by hosts): `gaming/cachyos.nix` sets `boot.kernelPackages = pkgs.linuxPackages_cachyos`, `hardware.nvidia.package = pkgs.nvidia_cachyos`, `services.scx.enable = true`; `gaming/gamescope.nix` sets `programs.gamescope.package = pkgs.gamescope_git`; `gaming/steam.nix` sets `extraCompatPackages = [pkgs.proton-cachyos pkgs.proton-ge-bin]` (cachyos + GE fallback). Bundle: import `nixos.gaming` per-host.

### Key evaluators

- **`configurations.nix`**: `flake.nixos.configurations.<name>` → `withSystem` → `nixpkgs.lib.nixosSystem`. Imports `default` + host `module` + `flake.modules.nixos.<name>` if exists (hostname match, e.g. `disko.nix`). Pins `system.stateVersion = "26.05"`, sets `networking.hostName`.
- **`users.nix`**: `flake.users.<name>` → `flake.modules.nixos.user-<name>`. Wires `home-manager.users.<name>` to `homeManager.default` + `home-manager` + optional per-user `homeManager.<name>`. Exposes `userMeta` (read by `git.nix`).
- **`home-manager.nix`**: imports home-manager nixosModule; derives `home.stateVersion` from `osConfig.system.stateVersion`. Pulled in by `users.nix` for every user.
- **`impermanence.nix`**: wraps `inputs.impermanence` for `/persist`-based root. Declares a `persistence.{directories,files}` option on `homeManager.default`/`nixos.default` (always imported → option exists everywhere, no option-not-found on non-ephemeral hosts). Any module sets it in its own body; the module system scopes it to whoever imports the module. Only `impermanence` consumes it (→ `home.persistence`/`environment.persistence`), and only on ephemeral hosts (auto-imported when `ephemeral = true`). BTRFS rollback (`btrfs`) is **separate** — host imports explicitly.
- **`modules/parts/`**: flake-level wiring — systems, perSystem pkgs (overlays + `allowUnfree`), `treefmt.nix` (formatter, via `treefmt-nix`), `pkgs-directory.nix` (auto-import `pkgs/` as flake packages + overlay).
- **`secrets.nix`**: wraps `inputs.sops-nix` for both `nixos.default`/`homeManager.default` (always imported → `sops.secrets.<name>` exists everywhere). Decryption key is a dedicated generated age key (`/var/lib/sops-nix/key.txt` for nixos, `~/.config/sops/age/keys.txt` per user), not the host SSH key (not persisted on ephemeral roots). Persists its own key path via `persistence.directories` — same pattern as any other module declaring persistence. Recipients (age public keys) are configured in `.sops.yaml` at the repo root; a module declaring a secret sets `sops.secrets.<name>.sopsFile` pointing at its own `secrets.yaml`.

## Hosts

| Host | System | Ephemeral | Notes |
|---|---|---|---|
| `cinnamon` | x86_64-linux | yes | Baremetal. disko GPT: ESP (1G, vfat, `/boot`, `umask=0077`) + swap (4G, `resumeDevice`) + root (LUKS `cryptroot` + BTRFS, subvolumes `root`->`/`, `persistent`->`/persistent`, `nix`->`/nix`). boot + btrfs + secureboot. |
| `paprika` | x86_64-linux | no | NixOS-WSL + graphics. |

## Inputs

- `nixpkgs` (unstable), `nixpkgs-stable` (nixos-26.05; via `pkgs.stable.<pkg>` overlay). Use `perSystem` `pkgs`, never raw `nixpkgs.legacyPackages`.
- `lanzaboote` (Secure Boot, `follows = "nixpkgs"`), `home-manager`, `impermanence`, `disko`, `determinate`, `nixos-wsl`, `llm-agents`, `sops-nix` (declarative secrets, `follows = "nixpkgs"`), `treefmt-nix` (formatter, `follows = "nixpkgs"`), `chaotic` (Chaotic-Nyx, `github:chaotic-cx/nyx/nyxpkgs-unstable`; vendored `nixpkgs` — **no `follows`**). Keep new inputs `follows = "nixpkgs"` unless version split intentional.
- `home.stateVersion` derived from `osConfig.system.stateVersion` — never set per-user.

## Chaotic-Nyx wiring

`modules/chaotic.nix` imports `inputs.chaotic.nixosModules.default` into `flake.modules.nixos.default` (applied to every host). `modules/parts/overlays.nix` additionally adds `inputs.chaotic.overlays.default` to `flake.overlays.default` → nyx packages (`linuxPackages_cachyos`, `gamescope_git`, `proton-cachyos`, `nvidia_cachyos`, `mesa_git`, etc.) available in every host's `pkgs`.

Cache: `cache.nix` adds `https://nyx-cache.chaotic.cx/` + key `nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk=` to `nix.settings.extra-substituters`/`extra-trusted-public-keys`.

**Cache hit invariant**: use `overlays.default` (builds nyx on **chaotic's nixpkgs**), NOT `overlays.cache-friendly` (builds nyx on user nixpkgs → hash diverges → cache miss → builds from source). Verify with:
```sh
nix eval --raw .#nixosConfigurations.<host>.config.boot.kernelPackages.kernel.outPath
nix eval --raw github:chaotic-cx/nyx/nyxpkgs-unstable#linuxPackages_cachyos.kernel.outPath
# must match
```

**mesa_git**: `chaotic.mesa-git.enable` breaks NVIDIA libgbm — do NOT enable on Optimus/Prime hosts (e.g. `cinnamon`). Only AMD-only.

## Commands

| Command | Purpose |
|---|---|
| `nix fmt` | Format (treefmt: alejandra + deadnix + statix) |
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
  `module` is where the user's home-manager imports live (`home-manager.users.<name> = { imports = with homeManager; [...]; ... }`). Optional `flake.modules.homeManager.<name>` for per-user home-manager config.
- **Declare persistence**: in a module's body, set `persistence.directories = [...]` and/or `persistence.files = [...]` (home-manager or NixOS). The option is declared on `default` (always imported), so it exists everywhere. Scope follows import: a module's paths persist only for hosts/users that import it, on ephemeral hosts only. Consumed by `impermanence.nix`.
- **Declare a secret**: put the encrypted file next to the module that needs it (e.g. `modules/foo/secrets.yaml`), add its recipients to `.sops.yaml`, then in the module set `sops.secrets.<name>.sopsFile = ./secrets.yaml;` (NixOS) or the home-manager equivalent. Read the decrypted value at runtime from `config.sops.secrets.<name>.path` (a path, never available at eval time — see `secrets.nix`).
- **Add a custom package**: drop `pkgs/<name>.nix` (a `callPackage`-style file `{stdenv, fetchFromGitHub, ...}: ...`). Auto-imported as `packages.<system>.<name>` (via `pkgs-directory.nix`) **and** into `pkgs.<name>` (via `overlays.nix`) — no manual wiring. `nix build .#<name>` and `nix-update <name> --flake` work out of the box. **`git add` new files** — flakes only see tracked files. No `passthru.updateScript`/`gitUpdater` needed in the package itself: the `.github/workflows/update-pkgs.yml` pipeline updates every package in `pkgs/` daily, one isolated job per package (matrix, inspired by numtide/llm-agents.nix), running `nix-update` (mic92/nix-update, an external non-Nix Python tool that patches `version`/hash directly in the `.nix` file) and opening/updating the package's own PR on a dedicated `update/<name>` branch — no per-package setup, no external script needed.
- **`helium.nix`**: no source-based nixpkgs recipe exists upstream — Helium is a full Chromium build, so the package repackages the prebuilt `.deb` published by `imputnet/helium-linux` releases (`fetchurl` + `dpkg`/`ar`+`tar` extraction + `patchelf` against a Nix-provided runtime closure + `wrapGAppsHook3`), the same pattern nixpkgs uses for `vivaldi`/`brave`. `nix-update --flake helium` still works out of the box (resolves the version from the GitHub releases feed).