{
  flake.modules.nixos.default = {
    security.polkit.enable = true;
  };
}
