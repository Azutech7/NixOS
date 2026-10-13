{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.common.security.network.adguard-home.enable = lib.mkEnableOption "common.security.network.adguard-home";

    config = lib.mkIf config.modules.common.security.network.adguard-home.enable {

        services.adguardhome = {
            enable = true;
            openFirewall = true;

            settings = {

                http = {
      				address = "0.0.0.0:8080";
    			};

                dns = {
                    bind_hosts = [ "100.118.213.98" "127.0.0.1" ]; # Bind to your Tailscale IP & localhost
                    port = 53;

                    # Forward allowed queries down to your local Unbound instance
                    upstream_dns = [
                        "127.0.0.1:5335" # Assuming Unbound is listening here
                    ];
                };

                # Fully declarative list management
                filtering = {
                    protection_enabled = true;
                    filtering_enabled = true;
                };

                # Declarative blocklists fetched and auto-updated automatically
                filters = [
                    {
                        enabled = true;
                        name = "Hagezi Multi PRO (Ad & Tracker Blocking)";
                        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
                    }
                ];
            };
        };

        services.caddy.virtualHosts = {

            "adguard.azutech.cc".extraConfig = ''
                tls internal
                reverse_proxy localhost:8080
            '';

        };

    };
}