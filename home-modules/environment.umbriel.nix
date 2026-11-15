{ inputs, config, lib, pkgs, ... }: {

    options.modules.environment.umbriel.enable = lib.mkEnableOption "environment.umbriel";

    config = lib.mkIf config.modules.environment.umbriel.enable {

        programs.umbriel = {
            enable = true;

            settings = {
                general = {
                    mod_key = "Super";
                    autostart = [ "noctalia" ];
                    xwayland = true;
                    xwayland_native_resolution = false;
                    xwayland_xsettings = true;
                    xwayland_primary_output = "";
                    nvidia_sync_workaround = true;
                    show_cheatsheet = true;
                    focus_on_activate = false;
                    attach_modal_dialogs = true;
                    honor_restored_maximize = false;
                };

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