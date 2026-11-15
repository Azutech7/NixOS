{ inputs, config, lib, pkgs, ... }: {

    options.modules.environment.umbriel.enable = lib.mkEnableOption "environment.umbriel";

    config = lib.mkIf config.modules.environment.umbriel.enable {

        programs.umbriel = {
            enable = true;

            settings = {
                # Set the modifier explicitly at the top level
                modifier = "super";
                
                # Correct key for starting applications on boot
                spawn_at_startup = [
                    [ "noctalia" ]
                ];

                # xwayland must be configured as a subtable or attribute set
                xwayland = {
                    enabled = true;
                };

                output."*" = {
                    scale = 1.0;
                    # Valid vrr options in Umbriel: "disabled", "always", "fullscreen", or "fullscreen_any"
                    vrr = "fullscreen";
                    layout.mode = "dwindle";

                    workspaces = "dynamic";
                    min_workspaces = 10;
                    workspace_axis = "vertical";
                };

                keybinds = {
                    # Umbriel action names use snake_case and correct verbs
                    "Mod+R" = "spawn noctalia msg launcher-toggle";
                    "Mod+T" = "spawn kitty";
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