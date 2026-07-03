topLevel: let
  inherit (topLevel.config.flake.modules) nixos;
in {
  flake.nixos.configurations.cinnamon = {
    system = "x86_64-linux";
    ephemeral = true;
    module = {pkgs, ...}: {
      imports = [
        nixos.btrfs
        nixos.secureboot
        nixos.user-tar
      ];

      networking.networkmanager.enable = true;

      # Kernel
      boot.initrd.availableKernelModules = ["xhci_pci" "nvme"];
      boot.kernelModules = ["kvm-intel"];
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    };
  };
}
