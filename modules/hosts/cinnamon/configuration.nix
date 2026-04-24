{config, ...}: {
  configurations.nixos.cinnamon = {
    system = "x86_64-linux";
    module = {
      imports = with config.flake.modules.nixos; [
        boot
        home-manager
        impermanence
        system
      ];
    };
  };
}
