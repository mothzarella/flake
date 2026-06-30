{
  flake.modules = {
    nixos.default = {pkgs, ...}: {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
        config.common.default = "*";
      };
    };

    homeManager.default = {pkgs, ...}: {
      xdg = {
        enable = true;
        mime.enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = true;
        };
        autostart.enable = true;
        mimeApps.enable = true;
      };

      home = {
        preferXdgDirectories = true;
        packages = with pkgs; [xdg-ninja];
      };
    };
  };
}
