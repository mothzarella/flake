{
  flake.modules.nixos.graphics = {pkgs, ...}: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

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
