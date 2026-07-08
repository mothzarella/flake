# https://github.com/drupol/pkgs-by-name-for-flake-parts
{
  lib,
  flake-parts-lib,
  config,
  ...
}: let
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options.pkgsDirectory = lib.mkOption {
    type = lib.types.path;
    default = ../../pkgs;
    description = ''
      Directory containing custom packages not present in nixpkgs.
    '';
  };

  options.perSystem = mkPerSystemOption (_: {
    options.pkgsDirectory = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = config.pkgsDirectory;
      description = ''
        Directory whose entries are auto-imported as packages. Each
        `<name>.nix` becomes `packages.<system>.<name>`; each
        `<name>/default.nix` becomes `packages.<system>.<name>.default`.
        Set to `null` to disable.
      '';
    };
  });

  config.perSystem = {
    config,
    pkgs,
    ...
  }: let
    imported = lib.filesystem.packagesFromDirectoryRecursive {
      directory = config.pkgsDirectory;
      inherit (pkgs) newScope callPackage;
    };
    flatten = path: value:
      if lib.isDerivation value
      then {${lib.concatStringsSep "/" path} = value;}
      else if lib.isAttrs value
      then lib.concatMapAttrs (name: flatten (path ++ [name])) value
      else {};
  in
    lib.mkIf (config.pkgsDirectory != null && builtins.pathExists config.pkgsDirectory) {
      legacyPackages = imported;
      packages = flatten [] imported;
    };
}
