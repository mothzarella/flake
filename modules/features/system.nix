{
  flake.modules.nixos.system = {
    system.stateVersion = "25.11";

    time.timeZone = "Europe/Rome";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    programs.nix-ld.enable = true;

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];

        download-buffer-size = 1024 * 1024 * 1024;
        auto-optimise-store = true;

        trusted-users = [
          "root"
          "@wheel"
        ];
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  };
}
