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

      environment.systemPackages = [
        pkgs.sbctl
      ];

      # NOTE:
      # `systemd-boot` loader must be disabled to avoid two conflicting loaders.
      # `efi.canTouchEfiVariables` (from modules/boot.nix) is still required.
      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        configurationLimit = 8;

        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          autoReboot = true;
          # Keep Microsoft keys so option ROMs (GPU, NIC) still validate.
          includeMicrosoftKeys = true;
        };
      };
    };
  };
}
