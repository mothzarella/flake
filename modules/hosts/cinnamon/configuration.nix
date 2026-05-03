{self, ...}: {
  configurations.nixos.cinnamon = {
    system = "x86_64-linux";
    module = {pkgs, ...}: {
      imports = with self.modules.nixos; [
        boot
        cachix
        home-manager
        impermanence
        networking
        niri
        ssh
        system

        # GPU
        nvidia
        opengl

        # Users
        tar
        iam
      ];

      boot.type = "lanzaboote";

      home-manager.users.tar = {
        imports = with self.modules.homeManager; [
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
