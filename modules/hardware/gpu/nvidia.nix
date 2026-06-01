{
  inputs,
  self,
  ...
}: {
  flake.modules.nixos.nvidia = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia-sync

      self.modules.nixos.gpu
    ];

    hardware.nvidia = {
      open = false;

      # TODO: Move prime busIds to `cinnamon` configuration.
      # prime = {
      #   # lspci | grep -E "VGA|3D"
      #   intelBusId = "PCI:0:2:0";
      #   nvidiaBusId = "PCI:1:0:0";
      # };

      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    hardware.graphics = {
      extraPackages = [pkgs.nvidia-vaapi-driver];
      extraPackages32 = [pkgs.nvidia-vaapi-driver];
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
