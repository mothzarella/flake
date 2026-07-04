{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-rules-cachyos;
    };
  };
}
