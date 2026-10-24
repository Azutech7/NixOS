{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.music-stack.soularr.enable = lib.mkEnableOption "services.music-stack.soularr";

    config = lib.mkIf config.modules.services.music-stack.soularr.enable {

        virtualisation.oci-containers.containers.soularr = {
            image = "m4m3ts/soularr:latest";
            autoStart = true;
            environment = {
                PUID = "1000";
                PGID = "1000";
                TZ = "America/Los_Angeles";
            };
            environmentFiles = [
                "/var/lib/music-stack/secrets.env"
            ];
            volumes = [
                "/var/lib/music-stack/soularr-config:/data"
                "/var/lib/music-stack/downloads:/downloads"
            ];
        };

    };
}
