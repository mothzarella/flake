{
  flake.modules.nixos.gaming = {
    programs.steam.gamescopeSession.enable = true;

    services.seatd.enable = true;

    programs.gamescope = {
      enable = true;
      enableWsi = true;
      capSysNice = true;
    };
  };
}
