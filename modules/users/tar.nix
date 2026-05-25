{self, ...}: {
  factory.user.tar = {isSudo = true;};

  flake.modules = {
    nixos.tar = {pkgs, ...}: {
      users.users.tar = {
        extraGroups = ["audio" "networkmanager"];
        shell = pkgs.fish;
      };

      programs.fish.enable = true;
    };

    homeManager.tar = {
      imports = with self.modules.homeManager; [
        fish
        tmux
      ];

      home.stateVersion = "26.05";

      programs.neovim.enable = true;
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "tar";
            email = "git@mothzarella.dev";
          };
          init.defaultBranch = "main";
        };
      };
    };
  };
}
