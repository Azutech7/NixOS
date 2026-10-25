{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.flaresolverr.enable = lib.mkEnableOption "services.flaresolverr";

    config = lib.mkIf config.modules.services.flaresolverr.enable {

        virtualisation.oci-containers.containers.flaresolverr = {
            image = "ghcr.io/flaresolverr/flaresolverr:latest";
            ports = [ "8191:8191" ];
            environment = {
                LOG_LEVEL = "info";
                TZ = "America/Los_Angeles";
            };
            extraOptions = [ "--restart=unless-stopped" ];
        };

    };
}
