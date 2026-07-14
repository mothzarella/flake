{inputs, ...}: {
  # https://docs.determinate.systems/determinate-nix
  flake.modules.nixos.default = {
    imports = [inputs.determinate.nixosModules.default];
  };
}
