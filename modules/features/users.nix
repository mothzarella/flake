{
  self,
  lib,
  ...
}: {
  flake.modules = lib.mkMerge [
    (self.factory.user {
      username = "iam";
      isAdmin = true;
    })

    # Default ------------------------------------------------------------------

    (self.factory.user {
      username = "tar";
      isAdmin = true;
    })
    {
      nixos.tar = {pkgs, ...}: {
        # imports = with self.modules.nixos; [
        #   # TODO: add modules
        # ];

        programs.fish.enable = true;

        users.users.tar = {
          extraGroups = ["audio"];
          shell = pkgs.fish;
        };
      };

      homeManager.tar = {
        pkgs,
        config,
        ...
      }: {
        imports = with self.modules.homeManager; [
          fish
          tmux
        ];

        home =
          {
            packages = with pkgs; [
              unzip

              llm-agents.junie
              llm-agents.claude-code
            ];
          }
          // self.lib.mkIfPersistence config {
            persistence."/persistent".directories = [".config/flake"];
          };

        programs = {
          neovim.enable = true;
          git = {
            enable = true;
            settings = {
              user = {
                name = "tar";
                email = "git@mothzarella.dev";
              };
              init.defaultBranch = "main";
            };
          };
        };
      };
    }
  ];
}
