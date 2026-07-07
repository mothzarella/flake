{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.wsl = {config, ...}: {
    imports = [inputs.nixos-wsl.nixosModules.default];

    wsl = {
      enable = true;
      docker-desktop.enable = true;
      useWindowsDriver = true;
      startMenuLaunchers = true;
    };

    # WSL graphics support — only when both WSL and graphics are active
    # https://github.com/nix-community/NixOS-WSL/issues/454
    environment.variables = lib.mkIf config.hardware.graphics.enable {
      GALLIUM_DRIVER = "d3d12";
      MESA_D3D12_DEFAULT_ADAPTER_NAME = lib.mkDefault "NVIDIA";
      LD_LIBRARY_PATH = "/usr/lib/wsl/lib:/run/opengl-driver/lib";
      LIBVA_DRIVER_NAME = "d3d12";
      VDPAU_DRIVER = "va_gl";
    };
  };
}
