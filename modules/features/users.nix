{
  config,
  lib,
  self,
  ...
}: {
  flake.modules = lib.mkMerge [
    (config.flake.factory.user {
      username = "iam";
      isAdmin = true;
    })

    # Default ------------------------------------------------------------------

    (config.flake.factory.user {
      username = "tar";
      isAdmin = true;
    })
    {
      nixos.tar = {
        imports = with self.modules.nixos; [
          # TODO: add modules
        ];

        users.users.tar = {
          extraGroups = ["audio"];
        };
      };

      homeManager.tar = {pkgs, ...}: {
        imports = with self.modules.homeManager; [
          # TODO: add modules
        ];

        home.packages = with pkgs; [
          unzip
        ];

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
