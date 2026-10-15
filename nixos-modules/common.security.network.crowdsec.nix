{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.common.security.network.crowdsec.enable = lib.mkEnableOption "common.security.network.crowdsec";

    config = lib.mkIf config.modules.common.security.network.crowdsec.enable {

        # 1. Enable Native CrowdSec Security Engine
        services.crowdsec = {
            enable = true;

            # The native nixpkgs module requires manual localConfig configuration for journalctl
            localConfig.acquisitions = [
                {
                    source = "journalctl";
                    journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
                    labels.type = "syslog";
                }
                {
                    source = "journalctl";
                    journalctl_filter = [ "_SYSTEMD_UNIT=caddy.service" ];
                    labels.type = "caddy";
                }
                {
                    source = "file";
                    filenames = [ "/var/log/audit/audit.log" ];
                    labels.type = "auditd";
                }
            ];
        };

        # Explicitly grant crowdsec permissions to read systemd logs 
        users.users.crowdsec.extraGroups = [ "systemd-journal" ];

        # 2. Enable Firewall Bouncer
        services.crowdsec-firewall-bouncer = {
            enable = true;
        };

        # 3. Ensure nftables is enabled for the bouncer
        networking.nftables.enable = lib.mkDefault true;
        
    };
}
