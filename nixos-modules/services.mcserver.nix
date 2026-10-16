{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.mcserver.enable = lib.mkEnableOption "services.mcserver";

    config = lib.mkIf config.modules.services.mcserver.enable {

        virtualisation.oci-containers.backend = "docker";

        virtualisation.oci-containers.containers.minecraft = {
            image = "itzg/minecraft-server";
            autoStart = true;

            stopGracePeriod = "60s";

            serviceConfig = {
                TimeoutStopSec = "120s";
            };

            ports = [ 
                "25565:25565"
                #"25575:25575"
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
                MOTD = "bello.";
                MAX_PLAYERS = "5";
                ENABLE_COMMAND_BLOCK = "true";
                ONLINE_MODE = "true";

                # Gameplay
                DIFFICULTY = "hard";
                PVP = "true";
                GAMEMODE = "survival";
                SPAWN_PROTECTION = "0";
                ALLOW_NETHER = "true";

                # Distances (3-32 inclusive)
                VIEW_DISTANCE = "32";
                SIMULATION_DISTANCE = "32";

                # Whitelist
                WHITE_LIST = "true";
                WHITELIST = ''
                    baf06ef8-2bfb-4dd9-b63b-8c3062934692 # Azutech
                    79cc72c7-cf43-4b8f-9174-2b7389cd6a25 # felhig82
                    1e520973-d267-43bc-94f9-7dde66124bac # BruceAwesomeVos
                    3776d8c7-fbab-4615-86af-fd9c5b738d98 # Eaten6191
                    797b59ab-def3-497d-947d-92785771fcd1 # LeLlama
                '';

                # Admin / Security
                OPS = ''
                    baf06ef8-2bfb-4dd9-b63b-8c3062934692 # Azutech
                '';
                ENABLE_RCON = "true";
                RCON_PASSWORD = "syt3aBEyt8fHXXeVEAznL4KkC2pR752n";

                # World Information
                LEVEL_SEED = "2026-10-16T20:00:00-0700"; # Time the server starts
                GENERIC_PACK = "/modpacks/Modpak_prism-launcher_v1.0.0.zip";

                # Stopping
                STOP_SERVER_ANNOUNCE_DELAY = "20";
                #STOP_SERVER_DELAY_COMMAND = "say Server is shutting down in 20 seconds! Saving world...";
            };

            volumes = [
                "/var/lib/mcserver/data:/data"
                "/var/lib/mcserver/modpacks:/modpacks:ro"
            ];
        };

#        services.caddy.virtualHosts = {
#            
#            "mcserver.azutech.cc".extraConfig = ''
#                tls internal
#                reverse_proxy localhost:25565
#            '';
#
#        };

    };
}
