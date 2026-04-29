{inputs, ...}: {
  flake.modules.nixos.impermanence = {
    lib,
    config,
    ...
  }: {
    imports = [inputs.impermanence.nixosModules.impermanence];

    options.impermanence = {
      type = lib.mkOption {
        type = lib.types.enum ["wsl" "bare-metal"];
        default = "bare-metal";
        description = "Impermanence mode: `wsl` or `bare-metal`.";
      };
      device = lib.mkOption {
        type = lib.types.str;
        default = "/dev/mapper/cryptroot";
        description = "The device containing the BTRFS root subvolume (e.g., /dev/mapper/cryptroot or /dev/vda2).";
      };
    };

    config = lib.mkMerge [
      {
        programs.fuse.userAllowOther = true;

        home-manager.sharedModules = [
          {
            home.persistence."/persistent" = {
              directories = [
                ".config/flake"
              ];
              files = [".bash_history"];
            };
          }
        ];
      }

      (lib.mkIf (config.impermanence.type == "bare-metal") {
        boot.initrd.systemd.services.rollback = {
          description = "Rollback BTRFS root subvolume to a pristine state";
          wantedBy = ["initrd.target"];
          after = ["systemd-cryptsetup@cryptroot.service"];
          before = ["sysroot.mount"];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /btrfs_tmp
            mount -o subvol=/ ${config.impermanence.device} /btrfs_tmp

            if [[ -e /btrfs_tmp/@root ]]; then
              mkdir -p /btrfs_tmp/@old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@root)" "+%Y-%m-%-d_%H:%M:%S")
              mv /btrfs_tmp/@root "/btrfs_tmp/@old_roots/$timestamp"
            fi

            delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              btrfs subvolume delete "$1"
            }

            for i in $(find /btrfs_tmp/@old_roots/ -mindepth 1 -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
            done

            btrfs subvolume create /btrfs_tmp/@root
            umount /btrfs_tmp
          '';
        };

        fileSystems."/persistent".neededForBoot = true;

        environment.persistence."/persistent" = {
          hideMounts = true;
          directories = [
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/etc/NetworkManager/system-connections"
            "/etc/ssh"
          ];
          files = [
            "/etc/machine-id"
            "/etc/shadow"
          ];
        };
      })

      (lib.mkIf (config.impermanence.type == "wsl") {
        fileSystems."/home/${config.wsl.defaultUser}" = {
          device = "none";
          fsType = "tmpfs";
          options = ["defaults" "size=1G" "mode=700" "uid=1000" "gid=100"];
          neededForBoot = true;
        };

        environment.persistence."/persistent" = {
          directories = [
            "/var/lib/nixos"
          ];
        };
      })
    ];
  };
}
