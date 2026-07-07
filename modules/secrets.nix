{inputs, ...}: {
  # `sops-nix` gives every host/user a `sops.secrets.<name>` option, decrypted
  # at activation from a per-module `secrets.yaml` (see `.sops.yaml` at the
  # repo root for recipients). Declared on `default` (always imported) so the
  # option exists everywhere; only modules that actually declare a secret pay
  # for it.
  flake.modules.nixos.default = {
    imports = [inputs.sops-nix.nixosModules.sops];

    # No usable host SSH key survives an ephemeral root wipe (not persisted),
    # so decryption uses a dedicated generated key instead of
    # `sops.age.sshKeyPaths`.
    sops.age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    # No-op on non-ephemeral hosts; keeps the key across root wipes otherwise.
    persistence.directories = ["/var/lib/sops-nix"];
  };

  flake.modules.homeManager.default = {config, ...}: {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    # Generate once per user with `age-keygen -o ~/.config/sops/age/keys.txt`.
    sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    persistence.directories = [".config/sops"];
  };
}
