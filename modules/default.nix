{lib, ...}: let
  fs = lib.fileset;
  isNixModule = file:
    file.hasExt "nix"
    && file.name != "default.nix";
in {
  imports =
    ./.
    |> fs.fileFilter isNixModule
    |> fs.toList;
}
