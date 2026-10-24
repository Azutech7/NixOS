{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.music-stack.lidarr.enable = lib.mkEnableOption "services.music-stack.lidarr";

    config = lib.mkIf config.modules.services.music-stack.lidarr.enable {

        virtualisation.oci-containers.containers.lidarr = {
            image = "lscr.io/linuxserver/lidarr:latest";
            autoStart = true;
            ports = [ "8686:8686" ];
            volumes = [
                "/var/lib/music-stack/lidarr-config:/config"
                "/var/lib/navidrome/music:/music"
                "/var/lib/music-stack/slskd-downloads:/downloads"
            ];
            environment = {
                PUID = "1000";
                PGID = "1000";
                TZ = "America/Los_Angeles";
            };
        };

    };
}
