{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.common.security.network.tailscale.enable = lib.mkEnableOption "common.security.network.tailscale";

    config = lib.mkIf config.modules.common.security.network.tailscale.enable {

        services.tailscale.enable = true;
        networking.firewall.trustedInterfaces = [ "tailscale0" ];

        boot.kernel.sysctl = {
            "net.ipv4.ip_forward" = 1;
            "net.ipv6.conf.all.forwarding" = 1;
        };

    };
}
