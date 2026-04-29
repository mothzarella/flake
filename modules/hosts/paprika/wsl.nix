{inputs, ...}: {
  flake.modules.nixos.paprika = {
    imports = [inputs.nixos-wsl.nixosModules.default];

    wsl = {
      enable = true;
      defaultUser = "tar";
    };
  };
}
