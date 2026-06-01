{
  flake.modules.homeManager.nushell = {
    self,
    osConfig,
    pkgs,
    ...
  }: {
    imports = with self.modules.homeManager; [
      carapace
      starship
    ];

    programs = {
      carapace.enableNushellIntegration = true;
      starship.enableNushellIntegration = true;
    };

    programs.nushell = {
      enable = true;
      extraConfig = ''
        # Carapace

        # https://www.nushell.sh/cookbook/external_completers.html#carapace-completer
        let carapace_completer = {|spans|
          carapace $spans.0 nushell ...$spans | from json
        }

        # NOTE: programs.nushell.settings doesn't support dynamic values, so we have to set the completer in extraConfig
        $env.config.completions.external.completer = $carapace_completer
      '';
      extraEnv = ''
        # NOTE: Prefer starship over the default nushell prompt
        $env.PROMPT_INDICATOR_VI_INSERT = ""
        $env.PROMPT_INDICATOR_VI_NORMAL = ""
        $env.PROMPT_MULTILINE_INDICATOR = ""
      '';
      settings = {
        show_banner = false;
        completions = {
          external.enable = true;
          algorithm = "fuzzy";
          case_sensitive = false;
          quick = true;
          partial = true;
        };

        # VI mode
        edit_mode = "vi";
        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
          emacs = "line";
        };
      };
      shellAliases = {
        cls = "clear";
        switch = "sudo nixos-rebuild switch --flake $\"($env.HOME)/.config/flake#${osConfig.networking.hostName}\"";
      };
    };
  };
}
