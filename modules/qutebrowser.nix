{
  flake = {
    persistence.homeManager.directories.modules = [
      ".local/share/qutebrowser"
      ".local/state/qutebrowser"
    ];
    modules.homeManager.browsers = {
      programs.qutebrowser = {
        enable = true;
      };
    };
  };
}
