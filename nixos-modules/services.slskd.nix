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
            environmentFiles = [ "/var/lib/mediastack/secrets.env" ];
            environment = {
                TZ = "America/Los_Angeles";
            };
            volumes = [
                "/var/lib/slskd:/app"
                "/var/lib/slskd/downloads:/downloads"
            ];
            extraOptions = [ "--restart=unless-stopped" ];
        };

    };
}
