{
  flake.modules.nixos.power = {
    services.thermald.enable = true; # Intel thermal protection
    services.power-profiles-daemon.enable = true; # `powerprofilesctl set power-saver|performance`
  };
}
