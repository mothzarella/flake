topLevel @ {inputs, ...}: let
  inherit (topLevel.config.flake.modules) nixos;
in {
  flake.nixos.configurations.cinnamon = {
    system = "x86_64-linux";
    ephemeral = true;
    module = {pkgs, ...}: {
      imports = [
        inputs.hardware.nixosModules.common-pc-laptop-ssd

        nixos.btrfs
        nixos.secureboot
        nixos.graphics
        nixos.nvidia
        nixos.power
        nixos.gaming
        nixos.gdm

        nixos.user-tar
      ];

      # Kernel
      boot.initrd.availableKernelModules = ["xhci_pci" "nvme"];
      boot.kernelModules = ["kvm-intel"];

      # Networking
      networking.networkmanager.enable = true;

      # Hardware
      hardware.cpu.intel.updateMicrocode = true;
    };
  };
}
