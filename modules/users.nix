topLevel @ {lib, ...}: {
  options.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = ''
            Display name. Defaults to the username (attr key).
          '';
        };

        email = lib.mkOption {
          type = lib.types.str;
          default = "${name}@example.com";
        };

        sudo = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        groups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
        };

        module = lib.mkOption {
          type = lib.types.deferredModule;
          default = {};
          description = ''
            A NixOS module defining system-level configuration for this user.
          '';
        };
      };
    }));
    default = {};
  };

  config.flake.modules.nixos = lib.mapAttrs' (username: user:
    lib.nameValuePair "user-${username}" {
      imports = [
        topLevel.config.flake.modules.nixos.home-manager
        user.module
      ];

      options.userMeta = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options.name = lib.mkOption {type = lib.types.str;};
          options.email = lib.mkOption {type = lib.types.str;};
        });
        default = {};
      };

      config = {
        users.users.${username} = {
          isNormalUser = true;
          home = "/home/${username}";
          extraGroups = lib.unique (user.groups ++ lib.optional user.sudo "wheel");
          initialPassword = "changeme";
        };

        userMeta.${username} = {
          name = user.name;
          email = user.email;
        };

        home-manager.users.${username} = {
          imports =
            [
              topLevel.config.flake.modules.homeManager.default
              topLevel.config.flake.modules.homeManager.home-manager
            ]
            ++ lib.optional
            (topLevel.config.flake.modules.homeManager ? "${username}")
            topLevel.config.flake.modules.homeManager."${username}";
        };
      };
    })
  topLevel.config.users;
}
