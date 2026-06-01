{
  config,
  lib,
  inputs,
  self,
  withSystem,
  ...
}: {
  options.factory.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
          };
          module = lib.mkOption {
            type = lib.types.deferredModule;
          };
        };
      }
    );
  };

  config.flake = {
    nixosConfigurations = lib.flip lib.mapAttrs config.factory.nixos (
      name: {
        system,
        module,
      }:
        withSystem system ({
          config,
          inputs',
          pkgs,
          ...
        }:
          inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs inputs';
              packages = config.packages;
              self = inputs.self;
            };

            modules = [
              {
                nixpkgs.hostPlatform = system;
                nixpkgs.pkgs = pkgs;
                networking.hostName = name;
              }

              self.modules.nixos.${name}
              self.modules.nixos.base
              module
            ];
          })
    );
  };
}
