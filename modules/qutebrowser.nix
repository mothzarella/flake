{
  flake = {
    persistence.homeManager.directories.modules = [
      ".local/share/qutebrowser"
      ".local/state/qutebrowser"
    ];
    modules.homeManager.browser = {
      programs.qutebrowser = {
        enable = true;
      };
    };
  };
}
