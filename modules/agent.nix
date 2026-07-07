{
  flake.modules.homeManager.agent = {pkgs, ...}: let
    piPath = ".pi/agent";
    fetchSkill = {
      owner,
      repo,
      rev ? "main",
      sha256,
    }:
      builtins.fetchurl {
        url = "https://raw.githubusercontent.com/${owner}/${repo}/${rev}/skills/${repo}/SKILL.md";
        inherit sha256;
      };
  in {
    programs.npm.enable = true;
    home.packages = with pkgs; [
      llm-agents.pi
    ];

    home.file = {
      "${piPath}/settings.json".text = builtins.toJSON {
        defaultProvider = "crofai";
        defaultModel = "glm-5.2";

        packages = [
          "npm:pi-mcp-adapter"
          "npm:@ryan_nookpi/pi-extension-headroom"
        ];

        skills = map fetchSkill [
          {
            owner = "JuliusBrussee";
            repo = "caveman";
            sha256 = "sha256-447Gcey+5HziNBkL4SYV2vYKxmfXdbc0DUnQf09jx7w=";
          }
          {
            owner = "dietrichgebert";
            repo = "ponytail";
            sha256 = "sha256:0a9wh092zg9azj1nny6694rdl5s7ds5iwi4paxypiaw6qkdwvzyi";
          }
        ];
      };

      "${piPath}/models.json".text = builtins.toJSON {
        providers = {
          crofai = {
            baseUrl = "https://crof.ai/v1";
            api = "openai-completions";
            apiKey = "nahcrof_dDpupfWPiWyHDlAfkFJQ";
            models = [{id = "glm-5.2";}];
          };
        };
      };

      "${piPath}/mcp.json".text = builtins.toJSON {
        mcpServers.nixos = {
          command = "nix";
          args = ["run" "github:utensils/mcp-nixos" "--"];
        };
      };
    };
  };
}
