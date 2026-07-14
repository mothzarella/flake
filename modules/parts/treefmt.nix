_: {
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        deadnix = {
          enable = true;
          priority = 1;
        };
        statix = {
          enable = true;
          priority = 2;
        };
        alejandra = {
          enable = true;
          priority = 3;
        };
      };
    };
  };
}
