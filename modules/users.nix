topLevel @ {lib, ...}: let
  inherit (topLevel.config.flake.modules) nixos homeManager;
in {
  options.flake.users = lib.mkOption {
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
    lib.nameValuePair "user-${username}" ({config, ...}: {
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
              homeManager.default
              homeManager.home-manager
            ]
            # Merge the home-manager module with the same username
            ++ lib.optional
            (homeManager ? "${username}")
            homeManager."${username}"
            # Add impermanence if the system is ephemeral
            ++ lib.optional
            (topLevel.config.flake.nixos.configurations.${config.networking.hostName}.ephemeral or false)
            homeManager.impermanence;
        };
      };
    }))
  topLevel.config.flake.users;
}
