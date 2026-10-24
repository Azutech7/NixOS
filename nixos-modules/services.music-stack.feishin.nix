{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.music-stack.feishin.enable = lib.mkEnableOption "services.music-stack.feishin";

    config = lib.mkIf config.modules.services.music-stack.feishin.enable {

        virtualisation.oci-containers.containers.feishin = {
            image = "ghcr.io/jeffvli/feishin:latest";
            autoStart = true;
            ports = [ "9180:9180" ];
            environment = {
                SERVER_NAME = "Navidrome";
                SERVER_TYPE = "navidrome";
                SERVER_URL = "http://172.17.0.1:4533";
                SERVER_LOCK = "true";
            };
        };

    };
}
