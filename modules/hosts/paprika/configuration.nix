{self, ...}: {
  factory.nixos = {
    paprika = {
      system = "x86_64-linux";
      module = {
        imports = with self.modules.nixos; [
          cachix
          opengl
          system
          tar
        ];
      };
    };
  };
}
