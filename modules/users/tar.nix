topLevel: let
  inherit (topLevel.config.flake.modules) homeManager;
in {
  flake.users.tar = {
    email = "git@mothzarella.dev";
    sudo = true;
    groups = [
      "docker"
      "networkmanager"
      "video"
      "seatd"
      "render"
    ];
    module = {
      home-manager.users.tar = {
        config,
        pkgs,
        ...
      }: {
        imports = with homeManager; [
          browsers
          discord
          zed
        ];

        programs.neovim.enable = true;
        programs.fastfetch.enable = true;

        persistence.directories = [
          ".config/flake"
          ".local/share/junie"
          ".hermes"
        ];

        home.packages = with pkgs; [
          llm-agents.opencode # TODO: remove after `pi` setup is complete
          llm-agents.junie

          # https://github.com/NousResearch/hermes-agent/pull/9087
          # llm-agents.hermes-agent
        ];

        # Cursor

        home.pointerCursor = {
          enable = true;
          gtk.enable = true;
          sway.enable = true;
          x11 = {
            enable = true;
            defaultCursor = config.stylix.cursor.name;
          };
          hyprcursor.size = config.stylix.cursor.size;
        };

        stylix.cursor = let
          getFrom = url: hash: name: {
            name = name;
            size = 24;
            package = pkgs.runCommand "moveUp" {} ''
              mkdir -p $out/share/icons
              ln -s ${
                pkgs.fetchzip {
                  url = url;
                  hash = hash;
                }
              } $out/share/icons/${name}
            '';
          };
        in
          getFrom
          "https://github.com/supermariofps/hatsune-miku-windows-linux-cursors/releases/download/1.2.6/miku-cursor-linux.tar.xz"
          "sha256-qxWhzTDzjMxK7NWzpMV9EMuF5rg9gnO8AZlc1J8CRjY="
          "miku-cursor-linux";
      };
    };
  };
}
