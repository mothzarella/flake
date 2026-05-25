{self, ...}: {
  factory.nixos = {
    cinnamon = {
      system = "x86_64-linux";
      module = {
        imports = with self.modules.nixos; [
          home-manager
          cachix
          firmware
          systemd
          lanzaboote
          opengl
          system
          tar
        ];
      };
    };
  };
}
