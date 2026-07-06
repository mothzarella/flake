{
  flake.modules.nixos.gaming = {
    lib,
    pkgs,
    ...
  }: {
    boot.kernelPackages = pkgs.linuxPackages_cachyos;
    services.scx.enable = true;

    hardware.nvidia.package = pkgs.nvidia_cachyos;
  };
}
