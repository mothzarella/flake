{
  flake.modules.homeManager.discord = {
    programs.vesktop = {
      enable = true;
      vencord.useSystem = true;
    };
    persistence.directories = [".config/vesktop"];
  };
}
