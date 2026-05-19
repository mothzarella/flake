{
  lib,
  self,
  ...
}: {
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = {};
  };

  config.flake.lib = {
    mkUser = {
      username,
      isAdmin ? false,
    }: {
      nixos."${username}" = {pkgs, ...}: {
        users.users."${username}" = {
          isNormalUser = true;
          home = "/home/${username}";
          extraGroups = lib.optionals isAdmin [
            "wheel"
          ];
        };

        home-manager.users."${username}" = {
          imports = [self.modules.homeManager."${username}"];
        };
      };

      homeManager."${username}" = {
        home.username = "${username}";
        home.stateVersion = "26.05";
      };
    };

    mkIfPersistence = config: settings:
      if config ? home
      then
        (
          if config.home ? persistence
          then settings
          else {}
        )
      else
        (
          if config.environment ? persistence
          then settings
          else {}
        );
  };
}
