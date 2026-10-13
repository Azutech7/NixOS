{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.mcserver.enable = lib.mkEnableOption "services.mcserver";

    config = lib.mkIf config.modules.services.mcserver.enable {

        virtualisation.oci-containers.backend = "docker";

        virtualisation.oci-containers.containers.minecraft = {
            image = "itzg/minecraft-server";

            autoStart = true;
            ports = [ 
                "25565:25565"
                "25575:25575"
            ];

            environment = {
                EULA = "TRUE";
                TYPE = "NEOFORGE";
                VERSION = "1.21.1";

                # Performance & Environment
                MEMORY = "12G";
                TZ = "America/Los_Angeles";
                UID = "1000";
                GID = "1000";

                # Server Properties
                MOTD = "Private";
                DIFFICULTY = "hard";
                MAX_PLAYERS = "10";
                PVP = "true";
                ENABLE_COMMAND_BLOCK = "true";
                #VIEW_DISTANCE = "12";

                # Admin / Security
                OPS = "Azutech";
                ENABLE_RCON = "true";
                RCON_PASSWORD = "super-secret-rcon-password";
            };

            volumes = [
                "/var/lib/minecraft:/data"
            ];
        };

        /*
        services.caddy.virtualHosts = {
            
            "mcserver.azutech.cc".extraConfig = ''
                tls internal
                reverse_proxy http://localhost:25565
            '';

        };
        */

    };
}
