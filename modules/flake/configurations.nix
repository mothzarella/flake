{
  config,
  lib,
  inputs,
  withSystem,
  ...
}: {
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          module = lib.mkOption {type = lib.types.deferredModule;};
          system = lib.mkOption {type = lib.types.str;};
        };
      }
    );
  };

  config.flake.nixosConfigurations = lib.flip lib.mapAttrs config.configurations.nixos (
    name: {
      module,
      system,
    }:
      withSystem system ({
        config,
        inputs',
        pkgs,
        ...
      }:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            packages = config.packages;
            inherit inputs inputs';
          };
          modules = [
            {
              nixpkgs.hostPlatform = system;
              nixpkgs.pkgs = pkgs;
              networking.hostName = name;
            }

            # Modules
            inputs.self.modules.nixos.${name}
            module
          ];
        })
  );
}
