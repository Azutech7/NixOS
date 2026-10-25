{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.slskd.enable = lib.mkEnableOption "services.slskd";

    config = lib.mkIf config.modules.services.slskd.enable {

        virtualisation.oci-containers.containers.slskd = {
            image = "slskd/slskd:latest";
            autoStart = true;
            ports = [
                "5030:5030"
                "5031:5031"
            ];
            environmentFiles = [ "/var/lib/slskd/secrets.env" ];
            environment = {
                TZ = "America/Los_Angeles";
                SLSKD_WEB_BIND_ADDRESS = "0.0.0.0";
            };
            volumes = [
                "/var/lib/slskd:/app"
                "/var/lib/media/downloads:/downloads"
            ];
        };

    };
}
