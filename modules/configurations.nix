topLevel @ {
  config,
  inputs,
  lib,
  withSystem,
  ...
}: {
  options.flake.nixos.configurations = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          ephemeral = lib.mkEnableOption ''
            Ephemeral root: auto-imports the impermanence NixOS module.
            The host is still responsible for importing btrfs/disko separately.
          '';
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
          ephemeral ? false,
          ...
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
                    inputs.chaotic.nixosModules.default
                  ]
                  ++ lib.optional
                  (topLevel.config.flake.modules.nixos ? ${name})
                  topLevel.config.flake.modules.nixos.${name}
                  # Auto-import impermanence when ephemeral
                  ++ lib.optional
                  ephemeral
                  topLevel.config.flake.modules.nixos.impermanence;
              }
          )
      )
      config.flake.nixos.configurations;

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
