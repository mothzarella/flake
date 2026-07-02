{
  flake.modules.nixos.networking = {pkgs, ...}: {
    networking.networkmanager.enable = true;
  };
}
