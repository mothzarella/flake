{
  flake = {
    persistence.homeManager.directories.modules = [".local/share/zed"];
    modules.homeManager.zed = {
      lib,
      pkgs,
      ...
    }: {
      programs.zed-editor = {
        enable = true;
        installRemoteServer = true;
        extensions = [
          "make"
          "nix"
          "terraform"
          "toml"
          "jetbrains-new-ui-icons"
          "vesper"
        ];
        userSettings = {
          vim_mode = true;

          # Theme
          theme = "Vesper";
          icon_theme = "JetBrains New UI Icons (Dark)";
          ui_font_family = "JetBrains Mono";
          buffer_font_family = "JetBrains Mono";
          ui_font_size = 15.0;
          buffer_font_size = 14.0;
          buffer_line_height = "comfortable";
          buffer_font_features = {
            "calt" = true;
          };

          # Classic Layout
          project_panel.dock = "left";
          outline_panel.dock = "left";
          collaboration_panel.dock = "left";
          git_panel.dock = "left";
          agent.dock = "right";

          instrumentation.performance_profiler.enabled = true;
          telemetry = {
            diagnostics = false;
            metrics = false;
            anthropic_retention = false;
          };

          node = {
            path = lib.getExe pkgs.nodejs;
            npm_path = lib.getExe' pkgs.nodejs "npm";
          };

          show_signature_help_after_edits = true;
          diagnostics.inline.enabled = true;
          inlay_hints = {
            show_background = true;
            enabled = true;
          };

          languages = {
            Nix = {
              language_servers = ["nil" "!nixd"];
              formatter.external = {
                command = "${lib.getExe pkgs.alejandra}";
                arguments = ["--quiet" "--"];
              };
            };
            Python = {
              language_servers = ["ty" "ruff" "!basedpyright"];
              code_actions_on_format."source.organizeImports.ruff" = true;
              formatter.language_server.name = "ruff";
            };
          };

          lsp = {
            nil = {
              binary.path = lib.getExe pkgs.nil;
              settings.diagnostics.ignored = ["unused_binding"];
            };
          };
        };
      };
    };
  };
}
