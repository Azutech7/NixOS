{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.music-stack.slskd.enable = lib.mkEnableOption "services.music-stack.slskd";

    config = lib.mkIf config.modules.services.music-stack.slskd.enable {

        virtualisation.oci-containers.containers.slskd = {
            image = "slskd/slskd:latest";
            autoStart = true;
            ports = [ "5030:5030" "2242:2242" ];
            environment = {
                PUID = "1000";
                PGID = "1000";
                SLSK   D_REMOTE_CONFIGURATION = "true";
            };
            environmentFiles = [
                "/var/lib/secrets.env"
            ];
            volumes = [
                "/var/lib/music-stack/slskd-config:/app"
                "/var/lib/music-stack/downloads:/downloads"
            ];
        };

    };
}
