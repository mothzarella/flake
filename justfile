default:
    @just --list

# Install ----------------------------------------------------------------------

luks-password:
    @read -sp "Password LUKS: " pass && echo -n "$pass" > /tmp/disk-password && echo " done"

disko host: luks-password
    sudo nix run github:nix-community/disko -- --mode disko .#nixosConfigurations.{{host}}

install host: (disko host)
    sudo nixos-install --flake .#{{host}} --no-root-passwd

# Post Install -----------------------------------------------------------------

enroll-keys:
    sudo sbctl verify
    sudo sbctl enroll-keys --microsoft
    @echo "Enable Secure Boot"

rebuild host:
    sudo nixos-rebuild switch --flake ~/.config/flake#{{host}}

update:
    nix flake update --flake ~/.config/flake

upgrade host: update (rebuild host)

gc:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
