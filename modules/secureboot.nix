topLevel @ {inputs, ...}: let
  inherit (topLevel.config.flake.modules) nixos;
in {
  flake = {
    persistence.nixos.directories = ["/var/lib/sbctl"];
    modules.nixos.secureboot = {
      pkgs,
      lib,
      ...
    }: {
      imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
        nixos.boot
      ];

      environment.systemPackages = with pkgs; [
        sbctl
      ];

      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";

        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          autoReboot = true;
        };
      };
    };
  };
}
