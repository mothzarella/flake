{
  flake.modules.nixos.systemd = {
    boot = {
      initrd.systemd.enable = true;
      loader.systemd-boot.enable = true;
    };
  };
}
