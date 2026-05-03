{inputs, ...}: {
  flake.modules.nixos.opengl = {
    config,
    lib,
    ...
  }: let
    isWsl = config.wsl.enable or false;
  in {
    config = lib.mkMerge [
      {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };
      }

      # WSL --------------------------------------------------------------------

      (lib.mkIf isWsl {
        environment.variables = {
          MESA_D3D12_DEFAULT_ADAPTER_NAME = "NVIDIA";
          GALLIUM_DRIVER = "d3d12";
        };

        environment.sessionVariables = {
          LD_LIBRARY_PATH = "/usr/lib/wsl/lib:/run/opengl-driver/lib";
        };
      })
    ];
  };

  flake.modules.nixos.nvidia = {config, ...}: let
    nvidiaPkg = config.hardware.nvidia.package;
  in {
    imports = [inputs.nixos-hardware.nixosModules.common-gpu-nvidia-sync];

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
