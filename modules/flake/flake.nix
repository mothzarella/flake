{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.modules

    # https://flake.parts/options/home-manager.html
    inputs.home-manager.flakeModules.home-manager
  ];
}
