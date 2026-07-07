{inputs, ...}: {
  flake.modules = {
    nixos.home-manager = {
      imports = [inputs.home-manager.nixosModules.home-manager];

      home-manager = {
        verbose = true;
        useGlobalPkgs = true;
        # https://github.com/nix-community/home-manager/issues/6770
        # useUserPackages = true;
        backupFileExtension = "backup";
        backupCommand = "rm";
        overwriteBackup = true;
      };
    };

    homeManager.home-manager = {osConfig, ...}: {
      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch";
      services.home-manager.autoExpire = {
        enable = true;
        timestamp = "-14 days";
        frequency = "weekly";
      };

      home.stateVersion = osConfig.system.stateVersion;
    };
  };
}
