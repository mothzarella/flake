{inputs, ...}: {
  flake.modules.nixos.cinnamon = {
    imports = [inputs.disko.nixosModules.disko];

    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-BC901_NVMe_SK_hynix_512GB__4YC6T000310706R22";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          swap = {
            size = "4G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              settings.allowDiscards = true;
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/persistent" = {
                    mountpoint = "/persistent";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
