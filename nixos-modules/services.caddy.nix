{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.caddy.enable = lib.mkEnableOption "services.caddy";

    config = lib.mkIf config.modules.services.caddy.enable {

        services.caddy = {
            enable = true;
            
            package = pkgs.caddy.withPlugins {
                plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20240410134750-6e4768393e15" ];
                hash = "sha256-nRFU5sXk59Hj6R7fB1U80K/y8x5SExx06Wz7mKxK2kM=";
            };

            environmentFile = "/var/lib/caddy/cloudflare.env";
        };

    };
}


