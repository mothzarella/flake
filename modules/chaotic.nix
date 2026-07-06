{inputs, ...}: {
  # https://github.com/chaotic-cx/nyx
  flake.modules.nixos.default = {
    imports = [inputs.chaotic.nixosModules.default];
  };
}
