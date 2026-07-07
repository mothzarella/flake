topLevel: let
  inherit (topLevel.config.flake.modules) nixos;
in {
  flake.nixos.configurations.paprika = {
    system = "x86_64-linux";
    profiles = ["wsl"];
    module = {pkgs, ...}: {
      imports = [
        nixos.user-tar
      ];

      wsl = {
        defaultUser = "tar";

        # https://github.com/zed-industries/zed/issues/52150
        extraBin = let
          coreutilsBins = builtins.attrNames (builtins.readDir "${pkgs.coreutils-full}/bin");
          mkExtraBin = name: {src = "${pkgs.coreutils-full}/bin/${name}";};
        in
          map mkExtraBin coreutilsBins;
      };
    };
  };
}
