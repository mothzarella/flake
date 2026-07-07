topLevel @ {inputs, ...}: let
  inherit (topLevel.config.flake.modules) nixos;
in {
  flake = {
    modules.nixos.secureboot = {
      pkgs,
      lib,
      ...
    }: {
      imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
        nixos.boot
      ];

      # Persisted here so the key bundle survives root rollback.
      persistence.directories = ["/var/lib/sbctl"];

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
