{
  flake.modules.homeManager.fish = {
    pkgs,
    lib,
    options,
    ...
  }: {
    config = {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting
          fish_hybrid_key_bindings
        '';
        shellAliases = with pkgs; {
          cls = "clear";
          ff = "${fastfetch}/bin/fastfetch";
          ls = "${lsd}/bin/lsd";
          r = "${ranger}/bin/ranger";
        };
        functions = {
          fish_mode_prompt = "";
          fish_prompt = ''
            set -l arrow "  "
            set_color normal
            echo -n (prompt_pwd -d 1)
            echo -n (fish_git_prompt)
            switch $fish_bind_mode
              case default
                set_color --bold red
                echo -n $arrow
              case insert
                set_color --bold magenta
                echo -n $arrow
              case replace_one
                set_color --bold green
                echo -n $arrow
              case visual
                set_color --bold brmagenta
                echo -n $arrow
              case '*'
                set_color --bold red
                echo -n $arrow
            end
            set_color normal
          '';
        };
      };
    } // lib.optionalAttrs (options ? home.persistence) {
      home.persistence."/persistent".files = [
        ".local/share/fish/fish_history"
      ];
    };
  };
}
