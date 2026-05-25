{
  flake.modules.nixos.niri = {pkgs, ...}: {
    programs.niri.enable = true;

    programs.uwsm = {
      enable = true;
      waylandCompositors.niri = {
        prettyName = "Niri";
        comment = "Niri scrollable-tiling Wayland compositor";
        binPath = "/run/current-system/sw/bin/niri";
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gnome];
    };

    programs.xwayland = {
      enable = true;
      package = pkgs.xwayland-satellite;
    };

    services.gnome.gnome-keyring.enable = true;

    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'uwsm start niri'";
        user = "greeter";
      };
    };
  };

  flake.modules.homeManager.niri = {config, ...}: {
    xdg.configFile = {
      "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    };
  };
}
