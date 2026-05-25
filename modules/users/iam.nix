{
  factory.user.iam = {isSudo = true;};

  flake.modules = {
    nixos.iam = {pkgs, ...}: {
      users.users.iam = {
        extraGroups = ["audio" "networkmanager"];
      };
    };
  };
}
