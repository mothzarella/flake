{self, ...}: {
  config.flake.factory.user = {
    username,
    isAdmin ? false,
  }: {
    nixos."${username}" = {
      lib,
      pkgs,
      ...
    }: {
      imports = [
        {
          users.users."${username}" = {
            isNormalUser = true;
            home = "/home/${username}";
            initialPassword = "changeme";
            extraGroups = lib.optionals isAdmin ["wheel" "networkmanager"];
            shell = pkgs.fish;
          };

          programs.fish.enable = true;

          home-manager.users."${username}".imports = [
            self.modules.homeManager."${username}"
          ];
        }
      ];
    };

    homeManager."${username}" = {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "26.05";
    };
  };
}
