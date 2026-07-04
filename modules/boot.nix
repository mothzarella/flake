{
  flake.modules.nixos.boot = {
    boot.initrd.systemd.enable = true;

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
