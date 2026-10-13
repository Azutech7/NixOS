{ inputs, pkgs, lib, host, config, ... }: {

	options.modules.common.security.network.unbound.enable = lib.mkEnableOption "common.security.network.unbound";

	config = lib.mkIf config.modules.common.security.network.unbound.enable {

		services.unbound = {
			enable = true;
			enableRootTrustAnchor = true;
			
			settings = {

				server = {
					interface = [ "127.0.0.1" "100.118.213.98" ]; # . , talescale
					port = 5335;
					access-control = [ "127.0.0.0/8 allow" "100.64.0.0/10 allow" ];
					
					do-ip4 = true;
					do-ip6 = false;

					do-udp = true;
      				do-tcp = true;

      				hide-version = true;
					prefetch = true;

					harden-dnssec-stripped = true;
					qname-minimisation-strict = true;

					do-not-query-localhost = false;

					module-config = "'respip validator iterator'";
				};

				rpz = [ # Response Policy Zones
					{
						name = "threat-intel-feed";
						url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/rpz/pro.txt";
      				}
				];

				forward-zone = [
					{
						name = ".";
						forward-addr = [ "127.0.0.1@5300" ];
					}
				];
			};
		};

		
		networking = {
			nameservers = lib.mkForce [ "127.0.0.1" ];
			networkmanager.dns = lib.mkForce "none";
		};

		services.resolved.enable = lib.mkForce false;

	};
}
