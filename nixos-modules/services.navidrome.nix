{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.navidrome.enable = lib.mkEnableOption "services.navidrome";

    config = lib.mkIf config.modules.services.navidrome.enable {

        services.navidrome = {
            enable = true;

            settings = {
                Address = "0.0.0.0";
                Port = 4533;

                MusicFolder = "/var/lib/navidrome/music";

                Scanner.Schedule = "@every 1h";
                TranscodingCacheSize = "1GB";
            };
        };

        systemd.tmpfiles.rules = [
            "d /var/lib/navidrome/music 0775 navidrome navidrome -"
        ];

        services.caddy.virtualHosts = {
            
            "navidrome.azutech.cc".extraConfig = ''
                tls internal
                reverse_proxy 0.0.0.0:4533
            '';

        };

    };
}