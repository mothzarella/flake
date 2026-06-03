{self, ...}: {
  factory.nixos = {
    cinnamon = {
      system = "x86_64-linux";
      module = {
        imports = with self.modules.nixos; [
          cpu
          firmware
          impermanence
          secure-boot
          tar
        ];
      };
    };
  };
}
