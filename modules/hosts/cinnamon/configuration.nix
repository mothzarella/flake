topLevel: let
  inherit (topLevel.config.flake.modules) nixos;
in {
  flake.nixos.configurations.cinnamon = {
    system = "x86_64-linux";
    ephemeral = true;
    module = {pkgs, ...}: {
      imports = with nixos; [
        btrfs
        graphics
        secureboot

        user-tar
      ];

      # Kernel
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
      boot.blacklistedKernelModules = ["nouveau"];
      boot.initrd.availableKernelModules = ["xhci_pci" "nvme"];
      boot.kernelModules = ["kvm-intel"];

      # Networking
      networking.networkmanager.enable = true;

      # Hardware
      hardware.cpu.intel.updateMicrocode = true;
    };
  };
}
