{
  flake = {
    modules.nixos.default = {
      security.pam.services.login.enableGnomeKeyring = true;
    };

    modules.homeManager.default = {pkgs, ...}: {
      services.gnome-keyring.enable = true;
      home.packages = with pkgs; [
        gcr
      ];
      # `default` is imported by every user, so this applies to all of them.
      persistence.directories = [".local/share/keyrings"];
    };
  };
}
