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
                        echo "Processing Packwiz .pw.toml files via Python parser..."
                        
                        CURRENT_MANIFEST="$TMP_DIR/active_mods.txt"
                        
                        # Use Python to safely parse TOMLs, fetch URLs, and write out clean manifests
                        ${pkgs.python3}/bin/python3 - <<EOF
import os
import glob
import urllib.request
import subprocess
import zipfile

index_dir = "$INDEX_DIR"
server_mods = "$SERVER_MODS"
client_mods = "$CLIENT_MODS_DIR"
current_manifest_path = "$CURRENT_MANIFEST"

active_mods = []

for toml_path in glob.glob(os.path.join(index_dir, "*.pw.toml")):
    url = None
    filename = None
    
    with open(toml_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line.startswith("url"):
                url = line.split("=", 1)[1].strip().strip('"\'')
            elif line.startswith("file"):
                filename = line.split("=", 1)[1].strip().strip('"\'')
                
    if not filename and url:
        filename = os.path.basename(url)
        
    if url and filename:
        active_mods.append(filename)
        
        target_dir = server_mods
        filename_lower = filename.lower()
        
        # Determine client vs server routing
        is_client = False
        if any(m in filename_lower for m in ["create_connected", "ritchiesprojectilelib"]):
            is_client = False
        elif any(m in filename_lower for m in ["sodium", "embeddium", "iris", "oculus", "entityculling", "reeses-sodium-options", "distanthorizons", "minihud", "xaero", "skinlayers3d"]):
            is_client = True
            
        if is_client:
            target_dir = client_mods
            
        final_jar = os.path.join(target_dir, filename)
        
        if os.path.exists(final_jar):
            print(f"Skipping existing matching mod: {filename}")
        else:
            print(f"Downloading new/updated mod: {filename}")
            tmp_jar = os.path.join("$TMP_DIR", filename)
            try:
                urllib.request.urlretrieve(url, tmp_jar)
                if os.path.exists(tmp_jar) and os.path.getsize(tmp_jar) > 0:
                    # Check jar metadata if not pre-categorized
                    if not is_client and not any(m in filename_lower for m in ["create_connected", "ritchiesprojectilelib"]):
                        try:
                            with zipfile.ZipFile(tmp_jar, 'r') as z:
                                jar_files = z.namelist()
                                if "META-INF/neoforge.mods.toml" in jar_files:
                                    content = z.read("META-INF/neoforge.mods.toml").decode("utf-8", errors="ignore")
                                    if 'side="client"' in content or "side = 'client'" in content or 'side = "client"' in content:
                                        target_dir = client_mods
                                        final_jar = os.path.join(target_dir, filename)
                        except Exception:
                            pass
                    
                    os.rename(tmp_jar, final_jar)
            except Exception as e:
                print(f"Failed to download {filename}: {e}")

with open(current_manifest_path, "w", encoding="utf-8") as mf:
    for m in active_mods:
        mf.write(m + "\n")
EOF

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
