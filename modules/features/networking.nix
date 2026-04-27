{
  flake.modules.nixos.networking = {pkgs, ...}: {
    networking = {
      networkmanager = {
        enable = true;
        wifi.powersave = true;
      };

      # Firewall
      firewall.enable = true;
    };

    # GUI: nm-connection-editor + nm-applet (tray)
    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}