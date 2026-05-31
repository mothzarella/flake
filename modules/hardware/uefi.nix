{
  flake.modules.nixos.uefi = {
    services.fwupd.enable = true;
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };
  };
}
