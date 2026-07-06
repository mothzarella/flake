topLevel @ {...}: {
  flake = {
    persistence.homeManager.directories.modules = [
      ".local/share/Steam"
      ".steam"
    ];
    modules.nixos.gaming = {
      pkgs,
      lib,
      ...
    }: {
      programs.steam = {
        enable = true;
        # package = pkgs.steam.override {
        #   extraPkgs = with pkgs; [
        #     bumblebee
        #     glxinfo
        #   ];
        # };

        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        extraCompatPackages = with pkgs; [
          proton-cachyos
          proton-ge-bin
        ];
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
