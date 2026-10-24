{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.music-stack.slskd.enable = lib.mkEnableOption "services.music-stack.slskd";

    config = lib.mkIf config.modules.services.music-stack.slskd.enable {

        virtualisation.oci-containers.containers.slskd = {
            image = "slskd/slskd:latest";
            autoStart = true;
            ports = [ "5030:5030" ];
            volumes = [
                "/var/lib/music-stack/slskd-config:/app"
                "/var/lib/music-stack/slskd-downloads:/downloads"
            ];
            environmentFiles = [ "/var/lib/music-stack/secrets.env" ];
        };

    };
}
