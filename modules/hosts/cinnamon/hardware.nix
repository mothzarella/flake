{
  flake.modules.nixos.cinnamon = {pkgs, ...}: {
    # Kernel
    boot.kernelPackages = pkgs.stable.linuxPackages_zen; # Stable linux_zen

    hardware.cpu.intel.updateMicrocode = true;
  };
}
