{
  flake.modules.nixos.default = {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ "tar" ];
      };
    };
  };
}
