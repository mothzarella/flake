# https://nix-community.github.io/NixOS-WSL
{inputs, ...}: {
  flake.modules.nixos.paprika = {pkgs, ...}: {
    imports = [inputs.nixos-wsl.nixosModules.default];

    wsl = {
      enable = true;
      defaultUser = "tar";
      docker-desktop.enable = true;
      useWindowsDriver = true;
      startMenuLaunchers = true;
    };

    # https://github.com/nix-community/NixOS-WSL/issues/454
    environment.variables = {
      GALLIUM_DRIVER = "d3d12";
      MESA_D3D12_DEFAULT_ADAPTER_NAME = "NVIDIA";
      LD_LIBRARY_PATH = "/usr/lib/wsl/lib:/run/opengl-driver/lib";
    };

    # TODO: create zed-editor module and move this there.
    home-manager.users.tar = {
      programs.zed-editor.enable = true;
    };
  };
}
