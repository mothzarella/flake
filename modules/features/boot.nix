{inputs, ...}: {
  flake.modules.nixos.boot = {
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [inputs.lanzaboote.nixosModules.lanzaboote];

    options.boot.type = lib.mkOption {
      type = lib.types.enum [
        "systemd-boot"
        "lanzaboote"
      ];
      default = "systemd-boot";
      description = "Boot loader type: systemd-boot or lanzaboote (Secure Boot)";
    };

    config = lib.mkMerge [
      {
        boot = {
          initrd.systemd.enable = true;
          loader.efi.canTouchEfiVariables = true;
        };
      }

      (lib.mkIf (config.boot.type == "systemd-boot") {
        boot.loader.systemd-boot.enable = true;
      })

      (lib.mkIf (config.boot.type == "lanzaboote") {
        boot.loader.systemd-boot.enable = lib.mkForce false;
        boot.lanzaboote = {
          enable = true;
          pkiBundle = "/etc/secureboot";
          autoGenerateKeys.enable = true;
        };

        environment = {
          systemPackages = [pkgs.sbctl];
          persistence."/persistent".directories = ["/etc/secureboot"];
        };
      })
    ];
  };
}
