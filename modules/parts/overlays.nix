{
  inputs,
  lib,
  ...
}: {
  flake.overlays.default = lib.composeManyExtensions [
    inputs.llm-agents.overlays.default
    # inputs.nix-cachyos-kernel.overlays.default

    (final: prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })
  ];
}
