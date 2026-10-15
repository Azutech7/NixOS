{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.docker.enable = lib.mkEnableOption "services.docker";

    config = lib.mkIf config.modules.services.docker.enable {

        virtualisation.docker = {
            enable = true;
            daemon.settings = {
                # Forces all containers on the default bridge to use loop-protection
                bridge = "docker0";
                "storage-driver" = "overlay2";
            };
        };

    };
}


