{
  inputs,
  lib,
  config,
  ...
}: {
  flake.overlays.default = lib.composeManyExtensions [
    inputs.llm-agents.overlays.shared-nixpkgs
    inputs.chaotic.overlays.default

    (final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })

    (_final: prev:
      lib.filesystem.packagesFromDirectoryRecursive {
        directory = config.pkgsDirectory;
        inherit (prev) newScope callPackage;
      })
  ];
}
