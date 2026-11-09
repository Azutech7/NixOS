{ inputs, pkgs, lib, host, config, ... }:

{
    fileSystems."/" = {
        device = "/dev/disk/by-uuid/<PRIMARY_PARTITION>";
        fsType = "btrfs";
        options = [ "subvol=rootfs" ];
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/<PRIMARY_PARTITION>";
        fsType = "btrfs";
        options = [ "subvol=home" "compress=zstd" ];
    };

    fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/<PRIMARY_PARTITION>";
        fsType = "btrfs";
        options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    fileSystems."/.swapvol" = {
        device = "/dev/disk/by-uuid/<PRIMARY_PARTITION>";
        fsType = "btrfs";
        options = [ "subvol=swap" ];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/<BOOT_PARTITION>";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [
        { device = "/.swapvol/swapfile"; }
    ];
}