{config, ...}: {
  configurations.nixos.cinnamon = {
    system = "x86_64-linux";
    module = {pkgs, ...}: {
      imports = with config.flake.modules.nixos; [
        boot
        home-manager
        impermanence
        networking
        niri
        nvidia
        ssh
        system

        # Users
        tar
        iam
      ];

      boot.type = "lanzaboote";

      home-manager.users.tar = {
        imports = with config.flake.modules.homeManager; [
          browser
          niri
          nvidia
        ];

        home.packages = with pkgs; [
          fuzzel
          alacritty
          brightnessctl
          wl-clipboard
        ];
      };
    };
  };
}
