{ inputs, pkgs, lib, host, config, ... }:

{
    fileSystems."/" = {
        device = "/dev/disk/by-uuid/87436851-1f0b-42bc-90a5-7867ca2dfbfc";
        fsType = "btrfs";
        options = [ "subvol=rootfs" ];
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/87436851-1f0b-42bc-90a5-7867ca2dfbfc";
        fsType = "btrfs";
        options = [ "subvol=home" "compress=zstd" ];
    };

    fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/87436851-1f0b-42bc-90a5-7867ca2dfbfc";
        fsType = "btrfs";
        options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    fileSystems."/.swapvol" = {
        device = "/dev/disk/by-uuid/87436851-1f0b-42bc-90a5-7867ca2dfbfc";
        fsType = "btrfs";
        options = [ "subvol=swap" ];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/51D7-A373";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [
        { device = "/.swapvol/swapfile"; }
    ];
}
