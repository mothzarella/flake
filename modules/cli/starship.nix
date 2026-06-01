{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      settings = {
        format = "$directory$git_branch$character";
        add_newline = false;

        directory = {
          format = "[$path]($style)";
          style = "white";
          truncate_to_repo = false;
          truncation_length = 3;
        };

        git_branch = {
          format = ":$branch";
          style = "white";
        };

        character = {
          success_symbol = "[ \\$](white)";
          error_symbol = "[ \\$](red)";
        };
      };
    };
  };
}
