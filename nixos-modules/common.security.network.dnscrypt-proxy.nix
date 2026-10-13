{ inputs, pkgs, lib, host, config, ... }: {

	options.modules.common.security.network.dnscrypt-proxy.enable = lib.mkEnableOption "common.security.network.dnscrypt-proxy";

	config = lib.mkIf config.modules.common.security.network.dnscrypt-proxy.enable {

		services.dnscrypt-proxy = {
				enable = true;
				settings = {
				
				server_names = [ "cloudflare" "quad9-dnscrypt-main" ];
				
				listen_addresses = [ "127.0.0.1:5300" ];

				require_dnssec = true;
				require_nofilter = false;
				require_nolog = true;

				ipv6_servers = false;
			};
		};

		networking = {
			nameservers = lib.mkForce [ "127.0.0.1" ];
			networkmanager.dns = lib.mkForce "none";
		};

		services.resolved.enable = lib.mkForce false;

	};
}
