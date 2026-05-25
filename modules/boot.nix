{inputs, ...}: {
  flake.modules.nixos.lanzaboote = {
    config,
    lib,
    options,
    pkgs,
    ...
  }: {
    imports = [inputs.lanzaboote.nixosModules.lanzaboote];
    config = {
      environment.systemPackages = [pkgs.sbctl];

      # Lanzaboote replaces the systemd-boot module.
      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    } // lib.optionalAttrs (options ? environment.persistence) {
      environment.persistence."/persistent".directories = ["/etc/secureboot"];
    };
  };

  flake.modules.nixos.systemd = {
    initrd.systemd.enable = true;
    boot.loader.systemd-boot.enable = true;
  };
}
