{
  flake.modules.nixos.default = {pkgs, ...}: {
    programs.nix-ld.enable = true;
    environment.systemPackages = with pkgs; [
      nil
      alejandra
    ];

    nix.channel.enable = false;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];

    nix = {
      optimise.automatic = true;
      settings = {
        download-buffer-size = 1024 * 1024 * 1024;
        auto-optimise-store = true;
      };
    };

    nix.settings.trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
