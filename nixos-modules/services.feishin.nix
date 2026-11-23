{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.feishin.enable = lib.mkEnableOption "services.feishin";

    config = lib.mkIf config.modules.services.feishin.enable {

        virtualisation.oci-containers.containers.feishin = {
            image = "ghcr.io/jeffvli/feishin:latest";
            autoStart = true;
            ports = [ "9180:9180" ];
            environment = {
                PUID = "1000";
                PGID = "1000";
                TZ = "America/Los_Angeles";

                SERVER_NAME = "Navidrome";
                SERVER_TYPE = "navidrome";
                SERVER_URL = "https://navidrome.azutech.cc";

                SERVER_LOCK = "true";
                ANALYTICS_DISABLED = "true";
            };
        };

        services.caddy.virtualHosts = {

            "feishin.azutech.cc".extraConfig = ''
                tls {
                    dns cloudflare {$CLOUDFLARE_API_TOKEN}
                }
                reverse_proxy http://localhost:9180
            '';

        };

    };
}
