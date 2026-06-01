{inputs, ...}: {
  flake.modules.nixos.home-manager = {
    imports = [inputs.home-manager.nixosModules.home-manager];

    home-manager = {
      verbose = true;
      useGlobalPkgs = true;
      # https://github.com/nix-community/home-manager/issues/6770
      # useUserPackages = true;
      backupFileExtension = "backup";
      backupCommand = "rm";
      overwriteBackup = true;
      extraSpecialArgs = {
        inherit inputs;
        self = inputs.self;
      };
    };
  };
}
