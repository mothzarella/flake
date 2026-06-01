{
  flake.modules.nixos.networking = {pkgs, ...}: {
    networking = {
      networkmanager = {
        enable = true;
        wifi.powersave = true;
      };

      firewall.enable = true;
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
