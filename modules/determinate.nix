{inputs, ...}: {
  flake.modules.nixos.base = {pkgs, ...}: {
    # NOTE: garbage-collector is automatically managed by `determinate` module.
    imports = [inputs.determinate.nixosModules.default];
  };
}
