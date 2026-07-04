{
  flake.modules.nixos.gaming = {
    programs.steam.gamescopeSession.enable = true;

    programs.gamescope = {
      enable = true;
      capSysNice = true;

      env = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
    };
  };
}
