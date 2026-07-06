{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    programs.steam.gamescopeSession.enable = true;

    programs.gamescope = {
      enable = true;
      package = pkgs.gamescope_git;
      enableWsi = true;
      # https://github.com/NixOS/nixpkgs/issues/351516
      capSysNice = false;
      args = [
        "--fullscreen"
        "--mangoapp"
        "--force-grab-cursor"
      ];
    };
  };
}
