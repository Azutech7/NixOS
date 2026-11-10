{ inputs, pkgs, lib, host, config, ... }:

{
    fileSystems."/" = {
        device = "/dev/disk/by-partlabel/sanbar_disko_part";
        fsType = "btrfs";
        options = [ "subvol=rootfs" ];
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-partlabel/sanbar_disko_part";
        fsType = "btrfs";
        options = [ "subvol=home" "compress=zstd" ];
    };

    fileSystems."/nix" = {
        device = "/dev/disk/by-partlabel/sanbar_disko_part";
        fsType = "btrfs";
        options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    fileSystems."/.swapvol" = {
        device = "/dev/disk/by-partlabel/sanbar_disko_part";
        fsType = "btrfs";
        options = [ "subvol=swap" ];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-partlabel/ESP";
        fsType = "vfat";
        options = [ "umask=0077" ];
    };

    swapDevices = [
        { device = "/.swapvol/swapfile"; }
    ];
}