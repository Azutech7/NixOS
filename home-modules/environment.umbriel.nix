{ inputs, config, lib, pkgs, ... }: {

    options.modules.environment.umbriel.enable = lib.mkEnableOption "environment.umbriel";

    config = lib.mkIf config.modules.environment.umbriel.enable {

        programs.umbriel = {
            enable = true;

            settings = {
                mod_key = "Super";
                
                autostart = [
                    "noctalia"
                ];

                xwayland = true;

                output."*" = {
                    scale = 1.0;
                    vrr = "on-demand";
                    layout.mode = "dwindle";

                    workspaces = "dynamic";
                    min_workspaces = 10;
                    workspace_axis = "vertical";
                };

                keybinds = {
                    "Mod+R" = "spawn noctalia msg launcher-toggle";
                    "Mod+T" = "spawn kitty";
                    #"Mod+T" = { action = "spawn kitty"; repeat = false; };
                    "Mod+Q" = "window-close";
                    "Mod+F" = "window-fullscreen";
                    "Mod+Left" = "window-focus-left";
                    "Mod+Right" = "window-focus-right";
                    "Mod+V" = "window-toggle-floating";
                };
            };
        };

    };
}
