{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.music-stack.navidrome.enable = lib.mkEnableOption "services.music-stack.navidrome";

    config = lib.mkIf config.modules.services.music-stack.navidrome.enable {

        services.navidrome = {
            enable = true;
            settings = {
                Address = "0.0.0.0";
                Port = 4533;
                MusicFolder = "/var/lib/music-stack/music";
                Scanner.Schedule = "@every 5m";
                EnableDownloads = true;
                EnableSubsonicApi = true;
            };
        };

    };
}
