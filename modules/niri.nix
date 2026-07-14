{inputs, ...}: {
  flake.modules = {
    nixos.niri = {...}: {
      imports = [inputs.niri.nixosModules.niri];

      programs.niri.enable = true;

      programs.uwsm = {
        enable = true;
        waylandCompositors.niri = {
          prettyName = "Niri";
          comment = "Scrollable tiling Wayland compositor";
          binPath = "/run/current-system/sw/bin/niri-session";
        };
      };

      programs.xwayland.enable = true;

      environment.etc."uwsm/env".text = ''
        MOZ_ENABLE_WAYLAND=1
        _JAVA_AWT_WM_NONREPARENTING=1
        NIXOS_OZONE_WL=1
      '';
    };

    homeManager.niri = {pkgs, ...}: {
      # programs.niri.settings = {
      # };

      home.packages = with pkgs; [
        fuzzel
        alacritty
      ];
    };
  };
}
