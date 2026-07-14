{inputs, ...}: {
  flake.modules.nixos.default = {
    imports = [inputs.sops-nix.nixosModules.sops];

    sops.age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    persistence.directories = ["/var/lib/sops-nix"];
  };

  flake.modules.homeManager.default = {config, ...}: {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    persistence.directories = [".config/sops"];
  };
}
