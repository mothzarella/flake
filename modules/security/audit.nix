{
  flake.modules.nixos.default = {
    security = {
      auditd.enable = true;
      audit.enable = true;
    };
  };
}
