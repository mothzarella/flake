{
  inputs,
  self,
  ...
}: {
  flake.modules.nixos.secure-boot = {
    config,
    lib,
    options,
    pkgs,
    ...
  }: {
    imports = [
      inputs.lanzaboote.nixosModules.lanzaboote

      self.modules.nixos.systemd
    ];

    config =
      {
        environment.systemPackages = [pkgs.sbctl];

        # Lanzaboote replaces the systemd-boot module.
        boot.loader.systemd-boot.enable = lib.mkForce false;

        boot.lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
          autoGenerateKeys.enable = true;
          autoEnrollKeys.enable = true;
        };
      }
      // lib.optionalAttrs (options ? environment.persistence) {
        environment.persistence."/persistent".directories = ["/var/lib/sbctl"];
      };
  };
}
