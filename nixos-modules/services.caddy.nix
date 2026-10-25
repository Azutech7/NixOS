{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.caddy.enable = lib.mkEnableOption "services.caddy";

    config = lib.mkIf config.modules.services.caddy.enable {

        services.caddy = {
            enable = true;
            
            package = pkgs.caddy.withPlugins {
                plugins = [ "github.com/caddy-dns/porkbun@v0.2.0" ];
                hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
            };

            environmentFile = "/var/lib/caddy/cloudflare.env";
        };

    };
}


