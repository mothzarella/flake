{config, ...}: {
  nixos.configurations.paprika = {
    system = "x86_64-linux";
    module = {pkgs, ...}: {
      imports = with config.flake.modules.nixos; [
        graphics
        wsl
        user-tar
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
