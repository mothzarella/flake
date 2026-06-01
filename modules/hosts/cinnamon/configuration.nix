{self, ...}: {
  factory.nixos = {
    cinnamon = {
      system = "x86_64-linux";
      module = {
        imports = with self.modules.nixos; [
          cpu
          firmware
          nvidia
          secure-boot
          tar
        ];
      };
    };
  };
}
