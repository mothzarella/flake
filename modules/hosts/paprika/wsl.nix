{inputs, ...}: {
  flake.modules.nixos.paprika = {
    imports = [inputs.nixos-wsl.nixosModules.default];

    wsl = {
      enable = true;
      defaultUser = "tar";
      useWindowsDriver = true;
    };

    environment.variables = {
      MESA_D3D12_DEFAULT_ADAPTER_NAME = "NVIDIA";
    };

    home-manager.users.tar = {
      programs.zed-editor.enable = true;
    };
  };
}
