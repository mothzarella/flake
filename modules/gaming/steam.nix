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

      # https://github.com/fufexan/nix-gaming/blob/master/modules/platformOptimizations.nix
      boot.kernel.sysctl = {
        "kernel.sched_cfs_bandwidth_slice_us" = 3000;
        "net.ipv4.tcp_fin_timeout" = 5;
        "kernel.split_lock_mitigate" = 0;
        "vm.max_map_count" = 2147483642;
      };
    };
  };
}
