{
  inputs,
  lib,
  ...
}: {
  flake.overlays.default = lib.composeManyExtensions [
    inputs.llm-agents.overlays.default # LLM Agents
    inputs.nix-cachyos-kernel.overlays.default # CachyOS kernel

    # Stable
    (final: prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })
  ];
}
