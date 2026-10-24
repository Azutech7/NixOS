{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.music-stack.soularr.enable = lib.mkEnableOption "services.music-stack.soularr";

    config = lib.mkIf config.modules.services.music-stack.soularr.enable {

        virtualisation.oci-containers.containers.soularr = {
            image = "mrusse08/soularr:latest";
            autoStart = true;
            ports = [ "8265:8265" ];
            volumes = [
                "/var/lib/music-stack/soularr-config:/data"
                "/var/lib/music-stack/slskd-downloads:/downloads"
            ];
            environmentFiles = [ "/var/lib/music-stack/secrets.env" ];
            environment = {
                PUID = "1000";
                PGID = "1000";
                TZ = "America/Los_Angeles";
                SCRIPT_INTERVAL = "300";
                LIDARR_HOST_URL = "http://172.17.0.1:8686";
                LIDARR_DOWNLOAD_DIR = "/downloads";
                SLSKD_HOST_URL = "http://172.17.0.1:5030";
            };
        };

    };
}
