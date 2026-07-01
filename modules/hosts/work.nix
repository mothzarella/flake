# TODO: build nixos host (baremetal)

{config, ...}: {
  nixos.configurations.tin076 = {
    system = "x86_64-linux";
    module = {
      imports = with config.flake.modules.nixos; [
        user-tar
      ];
    };
  };
}
