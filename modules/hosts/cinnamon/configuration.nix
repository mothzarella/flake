topLevel: let
  inherit (topLevel.config.flake.modules) nixos;
in {
  flake.nixos.configurations.cinnamon = {
    system = "x86_64-linux";
    ephemeral = true;
    module = {pkgs, ...}: {
      imports = [
        nixos.btrfs
        nixos.secureboot
        nixos.user-tar
      ];

      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    };
  };
}
