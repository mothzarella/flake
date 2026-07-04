{
  flake.modules.nixos.graphics = {
    pkgs,
    lib,
    ...
  }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      # Intel UHD 770 (Gen 12 Xe): VA-API via intel-media-driver (libva-vdpau-driver is VDPAU/NVIDIA-legacy).
      # Vulkan/OpenGL Intel ICDs ship with `mesa`, auto-available via hardware.graphics.enable.
      extraPackages = with pkgs; [
        intel-media-driver
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
      ];
    };

    environment.systemPackages = with pkgs; [
      mesa-demos
      vulkan-tools
      libva-utils
    ];
  };
}
