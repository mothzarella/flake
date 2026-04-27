{
  flake.modules.nixos.boot = {
    boot = {
      initrd.systemd.enable = true;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
