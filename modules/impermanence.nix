topLevel @ {
  inputs,
  lib,
  ...
}: {
  options.flake.persistence = {
    nixos.directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        Absolute directories to persist under `/persist` at the system
        (NixOS) level, in addition to the impermanence module's defaults.
      '';
    };

    homeManager.directories = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = {};
      description = ''
        Home-relative directories to persist under `/persist` when the
        impermanence home-manager module is enabled for a user, keyed by
        username, or `all` to apply to every such user.
      '';
    };
  };

  config.flake.modules.nixos.impermanence = {
    imports = [inputs.impermanence.nixosModules.impermanence];

    environment.persistence."/persistent" = {
      hideMounts = true;
      directories =
        [
          "/var/log"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/etc/NetworkManager/system-connections"
        ]
        ++ topLevel.config.flake.persistence.nixos.directories;
      files = [
        "/etc/machine-id"
      ];
    };
  };

  config.flake.modules.homeManager.impermanence = {config, ...}: let
    username = config.home.username;
    persist = topLevel.config.flake.persistence.homeManager.directories;
  in {
    home.persistence."/persistent" = {
      directories =
        [
          {
            directory = ".gnupg";
            mode = "0700";
          }
          {
            directory = ".ssh";
            mode = "0700";
          }
        ]
        ++ (persist.modules or [])
        ++ (persist.${username} or []);
    };
  };
}
