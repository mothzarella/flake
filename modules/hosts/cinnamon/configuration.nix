topLevel: let
  inherit (topLevel.config.flake.modules) nixos;
in {
  flake.nixos.configurations.cinnamon = {
    system = "x86_64-linux";
    ephemeral = true;
    module = {
      imports = [
        nixos.btrfs
        nixos.secureboot
        nixos.user-tar
      ];
    };
  };
}
