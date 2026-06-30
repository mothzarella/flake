{inputs, ...}: {
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [inputs.self.overlays.default];
      config.allowUnfree = true;
    };

    formatter = pkgs.alejandra;
  };
}
