{self, ...}: let
  username = "tar";
in {
  flake.modules.nixos."${username}" = {pkgs, ...}: {
    users.users."${username}" = {
      isNormalUser = true;
      initialPassword = "changeme";
      shell = pkgs.fish;
    };

    home-manager.users."${username}" = {
      imports = [self.modules.homeManager."${username}"];
    };

    programs.fish.enable = true;
  };

  flake.modules.homeManager."${username}" = {pkgs, ...}: {
    home.username = "${username}";
    home.packages = with pkgs; [
      ffmpeg
    ];
  };
}
