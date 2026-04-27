{inputs, ...}: {
  flake.modules.nixos.nvidia = {config, ...}: let
    nvidiaPkg = config.hardware.nvidia.package;
  in {
    imports = [inputs.nixos-hardware.nixosModules.common-gpu-nvidia-sync];

    # OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Nvidia
    hardware.nvidia = {
      open = nvidiaPkg ? open && nvidiaPkg ? firmware;
      prime = {
        # lspci | grep -E "VGA|3D"
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  flake.modules.homeManager.nvidia = {
    home.sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "0";
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };
  };
}
