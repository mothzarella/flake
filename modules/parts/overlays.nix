{
  inputs,
  lib,
  ...
}: {
  flake.overlays.default = lib.composeManyExtensions [
    inputs.llm-agents.overlays.default
    inputs.chaotic.overlays.default
    # inputs.nix-cachyos-kernel.overlays.pinned

    (final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })
  ];
}
