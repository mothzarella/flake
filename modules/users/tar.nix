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
      home-manager.users.tar = {pkgs, ...}: {
        imports = with homeManager; [
          firefox
          discord
          zed
        ];

        programs.neovim.enable = true;
        programs.fastfetch.enable = true;
        persistence.directories = [".config/flake"];
        home.packages = with pkgs; [
          llm-agents.opencode # TODO: remove after `pi` setup is complete
          llm-agents.junie
        ];
      };
    };
  };
}
