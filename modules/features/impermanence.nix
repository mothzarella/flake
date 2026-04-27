{inputs, ...}: {
  flake.modules.nixos.impermanence = {
    imports = [inputs.impermanence.nixosModules.impermanence];

    boot.initrd.systemd.services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = ["initrd.target"];
      after = ["systemd-cryptsetup@cryptroot.service"];
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /btrfs_tmp
        mount -o subvol=/ /dev/mapper/cryptroot /btrfs_tmp

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

    programs.fuse.userAllowOther = true;

    # Directories ------------------------------------------------------------

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

    home-manager.sharedModules = [
      {
        home.persistence."/persistent" = {
          directories = [
            ".config/flake"
          ];
        };
      }
    ];
  };
}
