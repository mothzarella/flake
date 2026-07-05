topLevel @ {inputs, ...}: let
  inherit (topLevel.config.flake.modules) nixos;
in {
  flake.modules.nixos.nvidia = {config, ...}: {
    imports = [
      # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/nvidia/prime.nix
      inputs.hardware.nixosModules.common-gpu-nvidia
      nixos.graphics
    ];

    hardware.nvidia = {
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };
}
