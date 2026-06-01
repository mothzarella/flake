{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    # https://github.com/NixOS/nixpkgs/tags
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/CachyOS/linux-cachyos#nixos
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    llm-agents.url = "github:numtide/llm-agents.nix";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {imports = [./modules];};
}
