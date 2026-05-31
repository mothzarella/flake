{self, ...}: {
  factory.user.tar = {isSudo = true;};

  flake.modules = {
    nixos.tar = {pkgs, ...}: {
      users.users.tar = {
        extraGroups = ["audio" "networkmanager"];
        shell = pkgs.nushell;
      };
    };

    homeManager.tar = {pkgs, ...}: {
      imports = with self.modules.homeManager; [
        nushell
        tmux
      ];

      home = {
        stateVersion = "26.05";
        packages = with pkgs; [
          neovim
          emmylua-ls
          vimPlugins.nvim-treesitter.withAllGrammars
        ];
      };

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
