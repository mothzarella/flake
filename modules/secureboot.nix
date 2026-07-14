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

        configurationLimit = 8;

        # measuredBoot = {
        #   enable = true;
        #   pcrs = [
        #     0
        #     4
        #     7
        #   ];

        #   autoCryptenroll = {
        #     enable = true;
        #     device = "/dev/disk/by-partuuid/<UUID-partizione-luks>";
        #     autoReboot = true;
        #   };
        # };
      };
    };
  };
}
