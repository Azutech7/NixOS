{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.mcserver.backups.enable = lib.mkEnableOption "services.mcserver.backups";

    config = lib.mkIf config.modules.services.mcserver.backups.enable {

        virtualisation.oci-containers.containers.minecraft-backup = {
            image = "itzg/mc-backup";
            autoStart = true;

            environment = {
                RCON_HOST = "localhost";
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
