{ inputs, pkgs, lib, host, config, ... }:

{
    fileSystems."/" = {
        device = "/dev/disk/by-uuid/12e5fc52-7b28-4c0c-9351-d1cec4ac506e";
        fsType = "btrfs";
        options = [ "subvol=rootfs" ];
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/12e5fc52-7b28-4c0c-9351-d1cec4ac506e";
        fsType = "btrfs";
        options = [ "subvol=home" "compress=zstd" ];
    };

    fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/12e5fc52-7b28-4c0c-9351-d1cec4ac506e";
        fsType = "btrfs";
        options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    fileSystems."/.swapvol" = {
        device = "/dev/disk/by-uuid/12e5fc52-7b28-4c0c-9351-d1cec4ac506e";
        fsType = "btrfs";
        options = [ "subvol=swap" ];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/BCD4-3F87";
        fsType = "vfat";
        options = [ "umask=0077" ];
    };

    swapDevices = [
        { device = "/.swapvol/swapfile"; }
    ];
}