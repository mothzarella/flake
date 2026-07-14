topLevel @ {inputs, ...}: let
  inherit (topLevel.config.flake.modules) nixos homeManager;
in {
  flake.nixos.configurations.cinnamon = {
    system = "x86_64-linux";
    ephemeral = true;
    profiles = ["bare-metal"];
    module = {...}: {
      imports = [
        inputs.hardware.nixosModules.common-pc-laptop-ssd

        nixos.gaming
        nixos.nvidia
        nixos.user-tar
      ];

      home-manager.users.tar.imports = [
        homeManager.niri
      ];

      boot.initrd.availableKernelModules = ["xhci_pci" "nvme"];
      boot.kernelModules = ["kvm-intel"];

      hardware.cpu.intel.updateMicrocode = true;
      hardware.enableRedistributableFirmware = true;

      hardware.nvidia.prime = {
        # Verify with: lspci | grep -E "VGA|3D"
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      programs.gamescope.args = [
        "-W"
        "1920"
        "-H"
        "1080"
        "-r"
        "165"
      ];
    };
  };
}
