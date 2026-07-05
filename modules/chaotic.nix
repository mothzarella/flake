{inputs, ...}: {
  # Chaotic-Nyx overlay/cache/registry, applied to every host.
  # https://github.com/chaotic-cx/nyx
  flake.modules.nixos.default = {
    imports = [inputs.chaotic.nixosModules.default];
  };
}
