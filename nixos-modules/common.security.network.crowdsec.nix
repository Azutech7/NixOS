{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.common.security.network.crowdsec.enable = lib.mkEnableOption "common.security.network.crowdsec";

    config = lib.mkIf config.modules.common.security.network.crowdsec.enable {

        # 1. Enable CrowdSec Security Engine
        services.crowdsec = {
            enable = true;

            # Allow CrowdSec to read systemd-journal logs (for SSH, Caddy, etc.)
            allowLocalJournalAccess = true;

            # Install standard detection collections from the CrowdSec Hub
            hub = {
                collections = [
                    "crowdsecurity/linux"   # Basic Linux OS protection (SSH, sudo failures)
                    "crowdsecurity/caddy"   # Caddy reverse proxy protections
                    "crowdsecurity/auditd" # Adds parsing rules for auditd logs
                ];
            };

            # Define log acquisitions (what logs CrowdSec should scan)
            settings = {
                acquisitions = [
                    {
                    source = "file";
                    filenames = [ "/var/log/audit/audit.log" ];
                    labels.type = "auditd";
                    }
                    # Journal logs (SSH, system services) are handled automatically 
                    # via allowLocalJournalAccess = true
                ];
            };
        };

        # 2. Enable Firewall Bouncer (Enforces blocks via nftables)
        services.crowdsec-firewall-bouncer = {
            enable = true;
        };

        # 3. Ensure nftables is enabled for the bouncer
        networking.nftables.enable = lib.mkDefault true;
        
    };
}