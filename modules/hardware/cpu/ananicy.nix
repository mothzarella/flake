{
  flake.modules.nixos.cpu = {pkgs, ...}: {
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-rules-cachyos;
    };
  };
}
