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
            environment = {
                PUID = "1000";
                PGID = "1000";
                TZ = "America/Los_Angeles";
                SCRIPT_INTERVAL = "300";
                LIDARR_HOST_URL = "http://172.17.0.1:8686";
                LIDARR_API_KEY = "PASTE_LIDARR_API_KEY_HERE";
                LIDARR_DOWNLOAD_DIR = "/downloads";
                SLSKD_HOST_URL = "http://172.17.0.1:5030";
                SLSKD_API_KEY = "my_super_secret_slskd_key_12345";
            };
        };

    };
}
