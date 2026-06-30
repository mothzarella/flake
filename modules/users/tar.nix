{config, ...}: {
  users.tar = {
    email = "git@mothzarella.dev";
    sudo = true;
    groups = ["docker" "video"];
    module = {...}: {
      home-manager.users.tar = {pkgs, ...}: {
        imports = with config.flake.modules.homeManager; [
          zed
        ];

        home.packages = with pkgs; [
          llm-agents.opencode # TODO: remove after `pi` setup is complete
          llm-agents.junie
        ];
      };
    };
  };
}
