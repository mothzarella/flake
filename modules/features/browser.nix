{
  flake.modules.homeManager.browser = {pkgs, ...}: {
    home.packages = with pkgs; [
      vivaldi
      vivaldi-ffmpeg-codecs
    ];

    home.persistence."/persistent".directories = [
      ".config/vivaldi"
      "Downloads"
    ];
  };
}
