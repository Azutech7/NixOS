{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.rdt-client.enable = lib.mkEnableOption "services.rdt-client";

    config = lib.mkIf config.modules.services.rdt-client.enable {

        virtualisation.oci-containers.containers.rdt-client = {
            image = "rogerfar/rdtclient:latest";
            autoStart = true;
            ports = [ "6500:6500" ];
            environment = {
                PUID = "1000";
                PGID = "1000";
                TZ = "America/Los_Angeles";
            };
            volumes = [
                "/var/lib/rdtclient/config:/data/db"
                "/var/lib/media/downloads:/data/downloads"
            ];
            extraOptions = [ "--restart=unless-stopped" ];
        };

    };
}
