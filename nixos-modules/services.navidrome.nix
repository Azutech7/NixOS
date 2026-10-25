{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.navidrome.enable = lib.mkEnableOption "services.navidrome";

    config = lib.mkIf config.modules.services.navidrome.enable {

        virtualisation.oci-containers.containers.navidrome = {
            image = "deluan/navidrome:latest";
            autoStart = true;
            ports = [ "4533:4533" ];
            environment = {
                ND_SCANSCHEDULE = "1h";
                ND_LOGLEVEL = "info";
                ND_MUSICFOLDER = "/music";
            };
            volumes = [
                "/var/lib/navidrome/data:/data"
                "/var/lib/media/music:/music:ro"
            ];
        };

        services.caddy.virtualHosts = {

            "navidrome.azutech.cc".extraConfig = ''
                tls {
                    dns cloudflare {env.CLOUDFLARE_API_TOKEN}
                    ca https://acme-staging-v02.api.letsencrypt.org/directory
                }
                reverse_proxy http://localhost:4533
            '';

        };

    };
}
