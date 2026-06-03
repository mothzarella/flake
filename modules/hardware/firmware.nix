{
  flake.modules.nixos.firmware = {
    boot.loader.efi.canTouchEfiVariables = true;

    services.fwupd.enable = true;
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };
  };
}
