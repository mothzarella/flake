{config, ...}: {
  configurations.nixos.paprika = {
    system = "x86_64-linux";
    module = {pkgs, ...}: {
      imports = with config.flake.modules.nixos; [
        home-manager
        impermanence
        system

        # Users
        tar
      ];

      impermanence.type = "wsl";
    };
  };
}
