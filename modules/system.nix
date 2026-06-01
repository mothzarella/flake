{
  flake.modules.nixos.base = {pkgs, ...}: {
    system.stateVersion = "25.11";

    time.timeZone = "Europe/Rome";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      alejandra # Formatter
      nil # LSP
    ];

    nix = {
      channel.enable = false;

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
    };
  };
}
