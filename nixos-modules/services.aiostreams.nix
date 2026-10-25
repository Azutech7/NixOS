{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.aiostreams.enable = lib.mkEnableOption "services.aiostreams";

    config = lib.mkIf config.modules.services.aiostreams.enable {

        virtualisation.oci-containers.backend = "docker";

        virtualisation.oci-containers.containers.aiostreams = {
            image = "ghcr.io/viren070/aiostreams:latest";

            autoStart = true;
            ports = [ "3000:3000" ];

            volumes = [ "/var/lib/aiostreams:/app/data" ];
            # Prepare Locally:
            # sudo mkdir -p /var/lib/aiostreams && sudo tee /var/lib/aiostreams/secret.env > /dev/null <<EOF
            # > SECRET_KEY=$(sudo cat /var/lib/aiostreams/secret.env | grep SECRET_KEY | cut -d'=' -f2)
            # > BASE_URL=http://<LOCAL_SERVER_IP>:3000
            # > EOF
            # sudo chmod 755 /var/lib/aiostreams
            # sudo chmod 600 /var/lib/aiostreams/secret.env


            environmentFiles = [ "/var/lib/aiostreams/secret.env" ];

            extraOptions = [
                "--memory=4g"
                "--memory-swappiness=0"
                "--cpus=2"
                "--ulimit=nofile=2048:4096"
                "--log-driver=journald" 
            ];

        };

        #networking.firewall.allowedTCPPorts = [ 3000 ]; #tailscale instead

        services.caddy.virtualHosts = {
            
            "aiostreams.azutech.cc".extraConfig = ''
                tls {
                    dns cloudflare {env.CLOUDFLARE_API_TOKEN}
                    ca https://acme-staging-v02.api.letsencrypt.org/directory
                    resolvers 1.1.1.1 8.8.8.8
                }
                reverse_proxy http://localhost:3000
            '';

            "jellyfin.azutech.cc".extraConfig = ''
                tls {
                    dns cloudflare {env.CLOUDFLARE_API_TOKEN}
                    ca https://acme-staging-v02.api.letsencrypt.org/directory
                    resolvers 1.1.1.1 8.8.8.8
                }
                handle / { redir * /jellyfin 302 }
                handle { reverse_proxy localhost:3000 {
                    header_up X-Forwarded-Prefix /jellyfin
                }}
            '';

        };


    };
}