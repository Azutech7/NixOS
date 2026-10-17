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
                NEOFORGE_VERSION = "21.1.259";

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
                #GENERIC_PACK = "/modpacks/Modpak_prism-launcher_v1.0.1.zip";

                # Stopping
                STOP_SERVER_ANNOUNCE_DELAY = "20";
                #STOP_SERVER_DELAY_COMMAND = "say Server is shutting down in 20 seconds! Saving world...";
            };

            volumes = [
                "/var/lib/mcserver/data:/data"
                "/var/lib/mcserver/modpacks:/modpacks:ro"
            ];
        };

        systemd.services.minecraft-mod-sorter = {
            description = "Smart Packwiz modpack parser, downloader, and incremental sorter";
            before = [ "docker-mcserver.service" ];
            requiredBy = [ "docker-mcserver.service" ];
            wantedBy = [ "docker-mcserver.service" ];
            serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
            };
            script = ''
                MODPACK_ZIP="/var/lib/mcserver/modpacks/Modpak_prism-launcher_v1.0.1.zip"
                SERVER_MODS="/var/lib/mcserver/data/mods"
                CLIENT_MODS_DIR="/var/lib/mcserver/data/automodpack/host-modpack/mods"

                mkdir -p "$SERVER_MODS"
                mkdir -p "$CLIENT_MODS_DIR"

                if [ -f "$MODPACK_ZIP" ]; then
                    echo "Extracting Packwiz modpack zip..."
                    TMP_DIR=$(mktemp -d)
                    ${pkgs.unzip}/bin/unzip -q "$MODPACK_ZIP" -d "$TMP_DIR"

                    INDEX_DIR="$TMP_DIR/minecraft/mods/.index"
                    if [ -d "$INDEX_DIR" ]; then
                        echo "Processing Packwiz .pw.toml files..."
                        
                        CURRENT_MANIFEST="$TMP_DIR/active_mods.txt"
                        > "$CURRENT_MANIFEST"

                        for toml in "$INDEX_DIR"/*.pw.toml; do
                            [ -f "$toml" ] || continue
                            
                            # Safely extract and strip any surrounding quotes, carriage returns, or spaces
                            DOWNLOAD_URL=$(grep -E '^url\s*=' "$toml" | head -n 1 | cut -d'=' -f2 | tr -d '"'\''[:space:]\r')
                            JAR_NAME=$(grep -E '^file\s*=' "$toml" | head -n 1 | cut -d'=' -f2 | tr -d '"'\''[:space:]\r')
                            
                            if [ -z "$JAR_NAME" ] && [ -n "$DOWNLOAD_URL" ]; then
                                JAR_NAME=$(basename "$DOWNLOAD_URL" | tr -d '"'\''[:space:]\r')
                            fi

                            if [ -n "$DOWNLOAD_URL" ] && [ -n "$JAR_NAME" ]; then
                                echo "$JAR_NAME" >> "$CURRENT_MANIFEST"
                                
                                TARGET_DIR=""
                                FILENAME=$(echo "$JAR_NAME" | tr '[:upper:]' '[:lower:]')
                                IS_CLIENT=false

                                if [[ "$FILENAME" =~ (create_connected|ritchiesprojectilelib) ]]; then
                                    IS_CLIENT=false
                                elif [[ "$FILENAME" =~ (sodium|embeddium|iris|oculus|entityculling|reeses-sodium-options|distanthorizons|minihud|xaero) ]]; then
                                    IS_CLIENT=true
                                fi

                                if [ "$IS_CLIENT" = true ]; then
                                    TARGET_DIR="$CLIENT_MODS_DIR"
                                else
                                    TARGET_DIR="$SERVER_MODS"
                                fi

                                FINAL_JAR="$TARGET_DIR/$JAR_NAME"

                                if [ -f "$FINAL_JAR" ]; then
                                    echo "Skipping existing matching mod: $JAR_NAME"
                                else
                                    echo "Downloading new/updated mod: $JAR_NAME"
                                    TMP_JAR="$TMP_DIR/$JAR_NAME"
                                    ${pkgs.curl}/bin/curl -sL "$DOWNLOAD_URL" -o "$TMP_JAR"
                                    
                                    if [ -f "$TMP_JAR" ] && [ -s "$TMP_JAR" ]; then
                                        if ! [[ "$FILENAME" =~ (create_connected|ritchiesprojectilelib|sodium|embeddium|iris|oculus|entityculling|reeses-sodium-options|distanthorizons|minihud|xaero) ]]; then
                                            if ${pkgs.unzip}/bin/unzip -p "$TMP_JAR" META-INF/neoforge.mods.toml 2>/dev/null | grep -qi 'side\s*=\s*"client"'; then
                                                mv "$TMP_JAR" "$CLIENT_MODS_DIR/$JAR_NAME"
                                                continue
                                            elif ${pkgs.unzip}/bin/unzip -p "$TMP_JAR" META-INF/mods.toml 2>/dev/null | grep -qi 'side\s*=\s*"client"'; then
                                                mv "$TMP_JAR" "$CLIENT_MODS_DIR/$JAR_NAME"
                                                continue
                                            fi
                                        fi
                                        mv "$TMP_JAR" "$FINAL_JAR"
                                    fi
                                fi
                            fi
                        done

                        echo "Cleaning up outdated/replaced mods..."
                        for existing_jar in "$SERVER_MODS"/*.jar "$CLIENT_MODS_DIR"/*.jar; do
                            [ -f "$existing_jar" ] || continue
                            BASENAME=$(basename "$existing_jar")
                            if ! grep -qxF "$BASENAME" "$CURRENT_MANIFEST"; then
                                echo "Removing outdated/replaced mod: $BASENAME"
                                rm -f "$existing_jar"
                            fi
                        done
                    fi
                    rm -rf "$TMP_DIR"
                else
                    echo "Warning: Modpack zip not found at $MODPACK_ZIP"
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
