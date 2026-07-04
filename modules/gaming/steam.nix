topLevel @ {...}: {
  flake = {
    persistence.homeManager.directories.modules = [
      ".local/share/Steam"
      ".steam"
      ".config/gamescope"
    ];
    modules.nixos.gaming = {pkgs, ...}: {
      programs.steam = {
        enable = true;

        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        extraCompatPackages = [pkgs.proton-ge-bin];

        package = pkgs.steam.override {
          extraEnv = {
            __NV_PRIME_RENDER_OFFLOAD = "1";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            __VK_LAYER_NV_optimus = "NVIDIA_only";
          };
        };
      };
    };
  };
}
