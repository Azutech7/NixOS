{ inputs, config, lib, pkgs, ... }: {

    options.modules.environment.umbriel.enable = lib.mkEnableOption "environment.umbriel";

    config = lib.mkIf config.modules.environment.umbriel.enable {

        programs.umbriel = {
            enable = true;

            settings = {
                # Some versions of Umbriel expect 'mod' or 'mod_key' depending on the schema version. 
                # If 'mod_key' threw an unknown key, check your local dump-default for the modifier key name.
                mod_key = "Super";
                
                autostart = [
                    "noctalia"
                ];

                xwayland = true;

                output."*" = {
                    scale = 1.0;
                    vrr = "fullscreen";
                    layout.mode = "dwindle";
                    workspaces = "dynamic";
                    min_workspaces = 10;
                    workspace_axis = "vertical";
                };

                keybinds = {
                    "Mod+R" = "spawn noctalia msg launcher-toggle";
                    "Mod+T" = "spawn kitty";
                    # Use the actions that matched your local version or fallback to generic exec
                    "Mod+Q" = "close_window";
                    "Mod+F" = "fullscreen_window";
                    "Mod+Left" = "focus_window_left";
                    "Mod+Right" = "focus_window_right";
                    "Mod+V" = "toggle_floating";
                };
            };
        };

    };
}