{
  flake.modules.nixos.btrfs = {
    fileSystems = {
      "/persist".neededForBoot = true;
      "/nix".neededForBoot = true;
    };

    boot.initrd.systemd.enable = true;
    boot.initrd.supportedFilesystems = ["btrfs"];

    boot.initrd.systemd.services.rollback = {
      description = "Rollback BTRFS root subvolume to pristine state on every boot";
      wantedBy = ["initrd.target"];
      after = ["systemd-cryptsetup@cryptroot.service"];
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt
        mount -o subvol=/ /dev/mapper/cryptroot /mnt

        if [[ ! -e /mnt/root-blank ]]; then
          echo "IMPERMANENCE: creating blank root snapshot from current state..."
          btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
        else
          echo "IMPERMANENCE: rolling back root subvolume..."
          mkdir -p /mnt/old_roots
          timestamp=$(date --date="@$(stat -c %Y /mnt/root)" "+%Y-%m-%d_%H:%M:%S")
          mv /mnt/root "/mnt/old_roots/$timestamp"

          btrfs subvolume snapshot /mnt/root-blank /mnt/root

          delete_subvolume_recursively() {
            IFS=$'\n'
            for sub in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/mnt/$sub"
            done
            btrfs subvolume delete "$1"
          }
          for oldroot in $(find /mnt/old_roots -maxdepth 1 -mtime +30 2>/dev/null); do
            echo "IMPERMANENCE: pruning old root $oldroot..."
            delete_subvolume_recursively "$oldroot"
          done
        fi

        umount /mnt
      '';
    };
  };
}
