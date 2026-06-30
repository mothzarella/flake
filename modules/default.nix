{lib, ...}: let
  fs = lib.fileset;
  isModule = file:
    file.type
    == "regular"
    && file.hasExt "nix"
    && file.name != "default.nix";
in {
  imports =
    ./.
    |> fs.fileFilter isModule
    |> fs.toList;
}
