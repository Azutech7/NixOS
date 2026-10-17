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
            description = "Smart Prism Launcher modpack extractor and incremental sorter";
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
                    echo "Extracting modpack zip..."
                    TMP_DIR=$(mktemp -d)
                    ${pkgs.unzip}/bin/unzip -q "$MODPACK_ZIP" -d "$TMP_DIR"

                    # Locate the internal mods directory inside the extracted zip
                    MODS_SRC_DIR=$(find "$TMP_DIR" -type d -name "mods" | head -n 1)

                    if [ -n "$MODS_SRC_DIR" ] && [ -d "$MODS_SRC_DIR" ]; then
                        echo "Found mods directory at: $MODS_SRC_DIR"
                        
                        CURRENT_MANIFEST="$TMP_DIR/active_mods.txt"
                        > "$CURRENT_MANIFEST"

                        for jar in "$MODS_SRC_DIR"/*.jar; do
                            [ -f "$jar" ] || continue
                            JAR_NAME=$(basename "$jar")
                            echo "$JAR_NAME" >> "$CURRENT_MANIFEST"

                            TARGET_DIR=""
                            FILENAME=$(echo "$JAR_NAME" | tr "[:upper:]" "[:lower:]")
                            IS_CLIENT=false

                            # Forced server-side mods (including JEi for recipes/sync)
                            if [[ "$FILENAME" =~ (create_connected|ritchiesprojectilelib|jei) ]]; then
                                IS_CLIENT=false
                            # Forced client-side mods
                            elif [[ "$FILENAME" =~ (sodium|embeddium|iris|oculus|entityculling|reeses-sodium-options|distanthorizons|minihud|xaero|skinlayers3d) ]]; then
                                IS_CLIENT=true
                            fi

                            if [ "$IS_CLIENT" = true ]; then
                                TARGET_DIR="$CLIENT_MODS_DIR"
                            else
                                TARGET_DIR="$SERVER_MODS"
                            fi

                            FINAL_JAR="$TARGET_DIR/$JAR_NAME"

                            if [ -f "$FINAL_JAR" ]; then
                                echo "Skipping existing mod: $JAR_NAME"
                            else
                                echo "Sorting new/updated mod: $JAR_NAME -> $(basename "$TARGET_DIR")"
                                
                                # If going to server mods, check metadata unless explicitly forced
                                if [ "$TARGET_DIR" = "$SERVER_MODS" ]; then
                                    if ! [[ "$FILENAME" =~ (create_connected|ritchiesprojectilelib|jei|sodium|embeddium|iris|oculus|entityculling|reeses-sodium-options|distanthorizons|minihud|xaero|skinlayers3d) ]]; then
                                        if ${pkgs.unzip}/bin/unzip -p "$jar" META-INF/neoforge.mods.toml 2>/dev/null | grep -qi "side\s*=\s*\"client\""; then
                                            cp "$jar" "$CLIENT_MODS_DIR/$JAR_NAME"
                                            continue
                                        elif ${pkgs.unzip}/bin/unzip -p "$jar" META-INF/mods.toml 2>/dev/null | grep -qi "side\s*=\s*\"client\""; then
                                            cp "$jar" "$CLIENT_MODS_DIR/$JAR_NAME"
                                            continue
                                        fi
                                    fi
                                fi
                                
                                cp "$jar" "$FINAL_JAR"
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
                    else
                        echo "Warning: Could not find mods directory in $MODPACK_ZIP"
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
