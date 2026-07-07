{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      # Lower priority runs first; alejandra must format last so it has the
      # final say on style after deadnix/statix rewrite the code.
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
