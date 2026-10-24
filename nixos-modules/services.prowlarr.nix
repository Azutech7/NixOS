{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.prowlarr.enable = lib.mkEnableOption "services.prowlarr";

    config = lib.mkIf config.modules.services.prowlarr.enable {

        virtualisation.oci-containers.containers.prowlarr = {
            image = "lscr.io/linuxserver/prowlarr:latest";
            autoStart = true;
            ports = [ "9696:9696" ];
            environment = {
                PUID = "1000";
                PGID = "1000";
                TZ = "America/Los_Angeles";
            };
            volumes = [
                "/var/lib/prowlarr/config:/config"
            ];
        };

    };
}
