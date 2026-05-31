{
  config,
  lib,
  self,
  ...
}: {
  options.factory.user = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          isSudo = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      }
    );
  };

  config.flake.modules = {
    nixos = lib.flip lib.mapAttrs config.factory.user (
      username: {isSudo}: {
        lib,
        pkgs,
        ...
      }: {
        imports = [self.modules.nixos.home-manager];

        users.users.${username} = {
          isNormalUser = true;
          home = "/home/${username}";
          extraGroups = lib.optionals isSudo ["wheel"];
        };

        home-manager.users.${username}.imports = [
          self.modules.homeManager.${username}
        ];
      }
    );

    homeManager = lib.genAttrs (lib.attrNames config.factory.user) (username: {
      home = {
        username = username;
        enableNixpkgsReleaseCheck = false;
      };
    });
  };
}
