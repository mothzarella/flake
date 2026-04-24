{
  flake.modules.nixos.system = {
    programs.nix-ld.enable = true;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      download-buffer-size = 1024 * 1024 * 1024;
      auto-optimise-store = true;

      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
