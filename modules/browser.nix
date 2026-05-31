{
  flake.modules.homeManager.browser = {
    pkgs,
    lib,
    options,
    ...
  }: {
    config =
      {
        home.packages = with pkgs; [
          vivaldi
          vivaldi-ffmpeg-codecs
        ];
      }
      // lib.optionalAttrs (options ? home.persistence) {
        home.persistence."/persistent".directories = [
          ".config/vivaldi"
          "Downloads"
        ];
      };
  };
}
