{lib, ...}: {
  options.cryptroot = lib.mkOption {
    type = lib.types.str;
    default = "cryptroot";
    description = "Name of the LUKS device mapper";
  };
}
