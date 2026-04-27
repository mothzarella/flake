{config, ...}: {
  configurations.nixos.cinnamon = {
    system = "x86_64-linux";
    module = {pkgs, ...}: {
      imports = with config.flake.modules.nixos; [
        boot
        home-manager
        impermanence
        niri
        nvidia
        ssh
        system

        # Users
        tar
        iam
      ];

      home-manager.users.tar = {
        imports = with config.flake.modules.homeManager; [
          browser
          niri
          nvidia
        ];

        home.packages = [
          pkgs.teams-for-linux
        ];
      };
    };
  };
}
