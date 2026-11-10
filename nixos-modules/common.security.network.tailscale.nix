{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.common.security.network.tailscale = {
        enable = lib.mkEnableOption "common.security.network.tailscale";
        host = lib.mkEnableOption "common.security.network.tailscale.host";
    };

    config = lib.mkMerge [
        # 1. Base Tailscale service
        (lib.mkIf config.modules.common.security.network.tailscale.enable {
            services.tailscale.enable = true;
        })

        # 2. Host-specific routing & firewall settings | Mandatorily enables modules.common.security.network.tailscale.enable
        (lib.mkIf config.modules.common.security.network.tailscale.host {

            modules.common.security.network.tailscale.enable = lib.mkForce true;

            networking.firewall = {
                trustedInterfaces = [ "tailscale0" ];
                allowedUDPPorts = [ 41641 ];
            };

            boot.kernel.sysctl = {
                "net.ipv4.ip_forward" = 1;
                "net.ipv6.conf.all.forwarding" = 1;
            };
        })
    ];
}
