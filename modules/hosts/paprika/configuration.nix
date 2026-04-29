{self, ...}: {
  configurations.nixos.paprika = {
    system = "x86_64-linux";
    module = {pkgs, ...}: {
      imports = with self.modules.nixos; [
        cachix
        home-manager
        system

        # Users
        tar
      ];
    };
  };
}
