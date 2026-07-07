{
  flake.modules.homeManager.default = {
    config,
    osConfig,
    ...
  }: let
    username = config.home.username;
  in {
    programs.git = {
      enable = true;
      settings = {
        user = {
          inherit (osConfig.userMeta.${username}) name email;
        };
        branch.autosetuprebase = "always";
        init.defaultBranch = "main";
      };
    };
  };
}
