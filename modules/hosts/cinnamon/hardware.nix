{inputs, ...}: {
  flake.modules.nixos.cinnamon = {pkgs, ...}: {
    imports = with inputs.nixos-hardware.nixosModules; [
      common-pc-laptop-ssd
      common-cpu-intel
    ];

    boot = {
      kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
      kernelParams = ["intel_pstate=active"];
    };

    # CPU (Intel)
    hardware.cpu.intel.updateMicrocode = true;
    powerManagement.cpuFreqGovernor = "schedutil";
    services = {
      thermald.enable = true;
      irqbalance.enable = true;
      auto-cpufreq.enable = true;
    };

    # GPU (NVIDIA)
    hardware.nvidia.prime = {
      # lspci | grep -E "VGA|3D"
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
