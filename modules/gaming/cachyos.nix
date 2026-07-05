{
  flake.modules.nixos.gaming = {
    lib,
    pkgs,
    ...
  }: {
    # Chaotic-Nyx module is imported globally via modules/chaotic.nix.
    # boot.kernelPackages = lib.mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    boot.kernelPackages = pkgs.linuxPackages_cachyos;
    services.scx.enable = true;

    hardware.nvidia.package = pkgs.nvidia_cachyos;
  };
}
