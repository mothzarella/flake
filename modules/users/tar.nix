topLevel: let
  inherit (topLevel.config.flake.modules) homeManager;
in {
  flake = {
    persistence.homeManager.directories.modules = [".config/flake"];
    users.tar = {
      email = "git@mothzarella.dev";
      sudo = true;
      groups = [
        "docker"
        "networkmanager"
        "video"
      ];
      module = {
        home-manager.users.tar = {pkgs, ...}: {
          imports = with homeManager; [
            zed
          ];

          programs.neovim.enable = true;
          home.packages = with pkgs; [
            llm-agents.opencode # TODO: remove after `pi` setup is complete
            llm-agents.junie
          ];
        };
      };
    };
  };
}
