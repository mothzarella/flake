{inputs, ...}: {
  # https://github.com/nix-community/stylix
  flake.modules.nixos.default = {pkgs, ...}: {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = {
      enable = true;
      autoEnable = false;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    };
  };
}
