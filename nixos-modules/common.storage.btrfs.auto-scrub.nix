{ inputs, pkgs, lib, host, config, ... }: {

	options.modules.common.storage.btrfs.auto-scrub.enable = lib.mkEnableOption "common.storage.btrfs.auto-scrub";

	config = lib.mkIf config.modules.common.storage.btrfs.auto-scrub.enable {

        services.btrfs.autoScrub = {
            enable = true;
            interval = "monthly";
            fileSystems = [ "/" ];
        };

    };
}
