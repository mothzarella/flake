{inputs, ...}: {
  flake.modules.nixos.cinnamon = {pkgs, ...}: {
    imports = with inputs.nixos-hardware.nixosModules; [
      common-pc-laptop-ssd
      common-cpu-intel
    ];

    boot = {
      kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-x86_64-v3;
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
  };
}
