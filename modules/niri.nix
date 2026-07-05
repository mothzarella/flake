{
  flake.modules.nixos.niri = {pkgs, ...}: {
    programs.uwsm = {
      enable = true;
      waylandCompositors.niri = {
        prettyName = "Niri";
        comment = "Scrollable tiling Wayland compositor";
        binPath = "/run/current-system/sw/bin/niri-session";
      };
    };

    services.gnome.gnome-keyring.enable = true;

    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

    programs.xwayland = {
      enable = true;
      package = pkgs.xwayland-satellite;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      fuzzel
      alacritty
    ];
  };
}
