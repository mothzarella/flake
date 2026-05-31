{
  flake.modules.nixos.gpu = {pkgs, ...}: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        libva-vdpau-driver
        vulkan-validation-layers # Vulkan SDK validation layers (64-bit only)
      ];

      extraPackages32 = [pkgs.libva-vdpau-driver];
    };
  };

  flake.modules.homeManager.gpu = {pkgs, ...}: {
    home.packages = [pkgs.mesa-demos];
  };
}
