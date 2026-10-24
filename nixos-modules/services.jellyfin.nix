{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.jellyfin.enable = lib.mkEnableOption "services.jellyfin";

    config = lib.mkIf config.modules.services.jellyfin.enable {

        virtualisation.oci-containers.containers.jellyfin = {
            image = "jellyfin/jellyfin:latest";
            ports = [ "8096:8096" ]; # Default web UI port
            volumes = [
                "/var/lib/jellyfin/config:/config"
                "/var/lib/jellyfin/cache:/cache"
                "/var/lib/media/music:/media/music:ro" # Read-only access to host music folder
            ];
            extraOptions = [ "--restart=unless-stopped" ];
        };

    };
}
