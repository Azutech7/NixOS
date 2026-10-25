{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.lidarr.enable = lib.mkEnableOption "services.lidarr";

    config = lib.mkIf config.modules.services.lidarr.enable {

        virtualisation.oci-containers.containers.lidarr = {
            image = "lscr.io/linuxserver/lidarr:develop";
            autoStart = true;
            ports = [ "8686:8686" ];
            environment = {
                PUID = "1000";
                PGID = "1000";
                TZ = "America/Los_Angeles";
            };
            volumes = [
                "/var/lib/lidarr/config:/config"
                "/var/lib/media/music:/music" # Write access to organize and tag media
                "/var/lib/media/downloads:/downloads" # Shared download staging directory
            ];
        };

        services.caddy.virtualHosts = {

            "slskd.azutech.cc".extraConfig = ''
                tls {
                    dns cloudflare {$CLOUDFLARE_API_TOKEN}
                }
                reverse_proxy http://localhost:8686
            '';

        };

    };
}
