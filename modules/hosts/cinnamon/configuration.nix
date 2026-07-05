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
        nixos.nvidia
        nixos.power
        nixos.gaming
        nixos.gdm

        nixos.user-tar
      ];

      boot.initrd.availableKernelModules = ["xhci_pci" "nvme"];
      boot.kernelModules = ["kvm-intel"];

      networking.networkmanager.enable = true;

      hardware.cpu.intel.updateMicrocode = true;
      hardware.enableRedistributableFirmware = true;

      programs.steam.gamescopeSession.args = ["--prefer-vk-device" "8086:a78b"];
      hardware.nvidia.prime = {
        # Verify with: lspci | grep -E "VGA|3D"
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
