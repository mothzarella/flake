{
  inputs,
  lib,
  ...
}: let
  # `persistence.{directories,files}` lives on `default` (always imported on
  # every host/user), so the option exists everywhere — no option-not-found on
  # non-ephemeral hosts. Any module may set it; the module system scopes it to
  # whoever imports that module. Only `impermanence` consumes it to emit
  # `environment.persistence`/`home.persistence`, and only on ephemeral hosts.
  persistenceOptions = {
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
    files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };
in {
  config.flake.modules.nixos.default = {
    options.persistence = persistenceOptions;
  };

  config.flake.modules.homeManager.default = {
    options.persistence = persistenceOptions;
  };

  config.flake.modules.nixos.impermanence = {config, ...}: {
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
        ++ config.persistence.directories;
      files = ["/etc/machine-id"] ++ config.persistence.files;
    };
  };

  config.flake.modules.homeManager.impermanence = {config, ...}: {
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
        ++ config.persistence.directories;
      files = config.persistence.files;
    };
  };
}
