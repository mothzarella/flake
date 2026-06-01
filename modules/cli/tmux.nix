{
  flake.modules.homeManager.tmux = {pkgs, ...}: {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      extraConfig = ''
        set -g renumber-windows on
        set -g status-position top
      '';
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
      ];
    };
  };
}
