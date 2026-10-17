{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.mcserver.backups.enable = lib.mkEnableOption "services.mcserver.backups";

    config = lib.mkIf config.modules.services.mcserver.backups.enable {

        virtualisation.oci-containers.containers.mcserver-backups = {
            image = "itzg/mc-backup";
            autoStart = true;

            environment = {
                RCON_HOST = "172.17.0.1";
                RCON_PORT = "25575";
                RCON_PASSWORD = "syt3aBEyt8fHXXeVEAznL4KkC2pR752n";
                BACKUP_INTERVAL = "8h";
                PRUNE_BACKUPS_DAYS = "1";
            };

            volumes = [
                "/var/lib/mcserver/data:/data:ro"
                "/var/lib/mcserver/backups:/backups"
            ];
        };

    };
}
