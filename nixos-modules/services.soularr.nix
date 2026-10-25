{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.soularr.enable = lib.mkEnableOption "services.soularr";

    config = lib.mkIf config.modules.services.soularr.enable {

        virtualisation.oci-containers.containers.soularr = {
            image = "mrusitorio/soularr:latest";
            autoStart = true;
            environmentFiles = [ "/var/lib/soularr/secrets.env" ];
            environment = {
                LIDARR_URL = "http://127.0.0.1:8686";
                SLSKD_URL = "http://127.0.0.1:5030";
                RUN_INTERVAL = "900";
                TZ = "America/Los_Angeles";
            };
        };

    };
}
