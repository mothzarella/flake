{
  flake.modules.nixos.default = {
    security = {
      sudo.enable = false;
      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };
  };
}
