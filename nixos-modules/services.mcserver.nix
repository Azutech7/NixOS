{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.mcserver.enable = lib.mkEnableOption "services.mcserver";

    config = lib.mkIf config.modules.services.mcserver.enable {

        virtualisation.oci-containers.backend = "docker";

        virtualisation.oci-containers.containers.mcserver = {
            image = "itzg/minecraft-server";
            autoStart = true;

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
                    baf06ef8-2bfb-4dd9-b63b-8c3062934692
                    79cc72c7-cf43-4b8f-9174-2b7389cd6a25
                    1e520973-d267-43bc-94f9-7dde66124bac
                    3776d8c7-fbab-4615-86af-fd9c5b738d98
                    797b59ab-def3-497d-947d-92785771fcd1
                '';

                # Admin / Security
                OPS = ''
                    baf06ef8-2bfb-4dd9-b63b-8c3062934692
                '';
                ENABLE_RCON = "true";
                RCON_PASSWORD = "syt3aBEyt8fHXXeVEAznL4KkC2pR752n";

                # World Information
                LEVEL_SEED = "2026-10-16T20:00:00-0700"; # Time the server starts
                GENERIC_PACK = "/modpacks/Modpak_prism-launcher_v1.0.1.zip";

                # Stopping
                STOP_SERVER_ANNOUNCE_DELAY = "20";
                #STOP_SERVER_DELAY_COMMAND = "say Server is shutting down in 20 seconds! Saving world...";
            };

            volumes = [
                "/var/lib/mcserver/data:/data"
                "/var/lib/mcserver/modpacks:/modpacks:ro"
            ];
        };

        systemd.services."docker-minecraft" = {
            preStart = lib.mkBefore ''
                SERVER_MODS="/var/lib/mcserver/data/mods"
                CLIENT_MODS_DIR="/var/lib/mcserver/data/automodpack/host-modpack/mods"

                # Ensure directories exist
                mkdir -p "$SERVER_MODS"
                mkdir -p "$CLIENT_MODS_DIR"

                # 1. Purge/clean both folders to start fresh
                echo "Purging existing mod directories..."
                rm -rf "$SERVER_MODS"/*
                rm -rf "$CLIENT_MODS_DIR"/*

                # Note: If your zip extracts into $SERVER_MODS during container startup, 
                # you can adjust this script to run as a container entrypoint hook or 
                # ensure your source mods are placed where this script can evaluate them.
                # Assuming mods are present in $SERVER_MODS for sorting:

                if [ -d "$SERVER_MODS" ]; then
                    echo "Sorting NeoForge mods (Server vs Client)..."
                    for jar in "$SERVER_MODS"/*.jar; do
                        [ -f "$jar" ] || continue
                        
                        IS_CLIENT=false

                        # Check NeoForge metadata for client-side restriction
                        if ${pkgs.unzip}/bin/unzip -p "$jar" META-INF/neoforge.mods.toml 2>/dev/null | grep -q 'side\s*=\s*"client"'; then
                            IS_CLIENT=true
                        elif ${pkgs.unzip}/bin/unzip -p "$jar" META-INF/mods.toml 2>/dev/null | grep -q 'side\s*=\s*"client"'; then
                            IS_CLIENT=true
                        fi

                        # 2. MOVE client mods to the host-modpack folder instead of copying
                        if [ "$IS_CLIENT" = true ]; then
                            echo "Moving client-only mod to host-modpack: $(basename "$jar")"
                            mv "$jar" "$CLIENT_MODS_DIR/"
                        fi
                    done
                fi
            '';
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
