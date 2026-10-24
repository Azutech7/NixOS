{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.music-stack.enable = lib.mkEnableOption "services.music-stack";

    config = lib.mkIf config.modules.services.music-stack.enable {

        modules.services.music-stack = {
            aurral.enable = true;
            feishin.enable = true;
            lidarr.enable = true;
            navidrome.enable = true;
            navidrome.temp-cleaner.enable = true;
            slskd.enable = true;
            soularr.enable = true;
        };

        modules.services.docker.enable = true;

        systemd.tmpfiles.rules = [
            "d /var/lib/navidrome/music 0777 1000 1000 -"
            "d /var/lib/navidrome/music/Permanent 0777 1000 1000 -"
            "d /var/lib/navidrome/music/Temporary 0777 1000 1000 -"
            "d /var/lib/music-stack/slskd-downloads 0775 1000 1000 -"
            "d /var/lib/music-stack/lidarr-config 0775 1000 1000 -"
            "d /var/lib/music-stack/slskd-config 0775 1000 1000 -"
            "d /var/lib/music-stack/soularr-config 0775 1000 1000 -"
            "d /var/lib/music-stack/aurral-data 0775 1000 1000 -"
        ];

    };
}
