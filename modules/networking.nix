{
  flake.modules.nixos.networking = {pkgs, ...}: {
    networking = {
      networkmanager = {
        enable = true;
        wifi.powersave = false;
      };

      firewall.enable = true;
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
