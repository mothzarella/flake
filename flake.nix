{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    # https://github.com/NixOS/nixpkgs/tags
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    llm-agents.url = "github:numtide/llm-agents.nix";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    impermanence.url = "github:nix-community/impermanence";
    disko.url = "github:nix-community/disko";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {imports = [./modules];};
}
