{
  flake.modules.nixos.systemd = {
    initrd.systemd.enable = true;
    boot.loader.systemd-boot.enable = true;
  };
}
