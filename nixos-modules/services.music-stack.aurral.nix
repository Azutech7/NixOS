{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.music-stack.aurral.enable = lib.mkEnableOption "services.music-stack.aurral";

    config = lib.mkIf config.modules.services.music-stack.aurral.enable {

        virtualisation.oci-containers.containers.aurral = {
            image = "ghcr.io/lklynet/aurral:latest";
            autoStart = true;
            ports = [ "3001:3001" ];
            volumes = [
                "/var/lib/music-stack/aurral-data:/data"
                "/var/lib/navidrome/music:/music"
            ];
            environment = {
                TZ = "America/Los_Angeles";
            };
        };

    };
}
