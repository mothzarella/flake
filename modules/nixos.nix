{
  flake.modules.nixos.default = {pkgs, ...}: {
    programs.nix-ld.enable = true;
    environment.systemPackages = with pkgs; [
      nil
      alejandra
    ];

    nix = {
      channel.enable = false;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

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
