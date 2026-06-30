{
  flake.modules.nixos.graphics = {
    pkgs,
    lib,
    ...
  }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        libva-vdpau-driver
        vulkan-validation-layers # Vulkan SDK validation layers (64-bit only)
      ];

      extraPackages32 = [pkgs.libva-vdpau-driver];
    };

    environment.systemPackages = with pkgs; [
      mesa-demos
      vulkan-tools
      libva-utils
    ];
  };
}
