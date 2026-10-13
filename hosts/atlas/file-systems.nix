{ config, lib, pkgs, ... }:

{
    fileSystems."/" = {
        device = "/dev/disk/by-uuid/23a08703-5d8f-4418-870b-dea3f57f536a";
        fsType = "btrfs";
        options = [ "subvol=rootfs" ];
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/23a08703-5d8f-4418-870b-dea3f57f536a";
        fsType = "btrfs";
        options = [ "subvol=home" "compress=zstd" ];
    };

    fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/23a08703-5d8f-4418-870b-dea3f57f536a";
        fsType = "btrfs";
        options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    fileSystems."/.swapvol" = {
        device = "/dev/disk/by-uuid/23a08703-5d8f-4418-870b-dea3f57f536a";
        fsType = "btrfs";
        options = [ "subvol=swap" ];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/6F60-5849";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [
        { device = "/.swapvol/swapfile"; }
    ];
}