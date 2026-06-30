topLevel @ {
  config,
  inputs,
  lib,
  withSystem,
  ...
}: {
  options.nixos.configurations = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.enum ["x86_64-linux" "aarch64-linux"];
            default = "x86_64-linux";
            description = ''
              The system architecture to build the configuration for.
            '';
          };
          module = lib.mkOption {
            type = lib.types.deferredModule;
            default = {};
            description = ''
              The NixOS module defining the configuration for this system.
            '';
          };
        };
      }
    );
    default = {};
  };

  config.flake = {
    nixosConfigurations =
      lib.mapAttrs (
        name: {
          system,
          module,
        }:
          withSystem system (
            {
              config,
              pkgs,
              ...
            }:
              inputs.nixpkgs.lib.nixosSystem {
                modules =
                  [
                    {
                      networking.hostName = name;
                      system.stateVersion = "26.05";
                      nixpkgs = {
                        inherit pkgs;
                        hostPlatform = system;
                      };
                    }

                    topLevel.config.flake.modules.nixos.default
                    module
                  ]
                  ++ lib.optional
                  (topLevel.config.flake.modules.nixos ? ${name})
                  topLevel.config.flake.modules.nixos.${name};
              }
          )
      )
      config.nixos.configurations;

    checks =
      config.flake.nixosConfigurations
      |> lib.mapAttrsToList (
        name: nixos: {
          ${nixos.config.nixpkgs.hostPlatform.system} = {
            "configurations:nixos:${name}" = nixos.config.system.build.toplevel;
          };
        }
      )
      |> lib.mkMerge;
  };
}
