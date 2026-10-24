{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.music-stack.navidrome.temp-cleaner.enable = lib.mkEnableOption "services.music-stack.navidrome.temp-cleaner";

    config = lib.mkIf config.modules.services.music-stack.navidrome.temp-cleaner.enable {

        systemd.services.navidrome-temp-cleaner = {
            description = "Clean up temporary music files older than 7 days";
            serviceConfig = {
                Type = "oneshot";
                User = "root";
            };
            script = ''
                ${pkgs.findutils}/bin/find /var/lib/music-stack/music/Temporary -mindepth 1 -mmin +10080 -delete
                ${pkgs.findutils}/bin/find /var/lib/music-stack/music/Temporary -mindepth 1 -type d -empty -delete
            '';
        };

        systemd.timers.navidrome-temp-cleaner = {
            description = "Daily timer for temporary music folder cleanup";
            wantedBy = [ "timers.target" ];
            timerConfig = {
                OnCalendar = "daily";
                Persistent = true;
            };
        };

    };
}
