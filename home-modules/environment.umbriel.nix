{ inputs, config, lib, pkgs, ... }: {

    options.modules.environment.umbriel.enable = lib.mkEnableOption "environment.umbriel";

    config = lib.mkIf config.modules.environment.umbriel.enable {

        programs.umbriel = {
            enable = true;

            settings = {
                include.optional = {
                    files = [ "${config.home.homeDirectory}/.config/umbriel/noctalia.toml" ];
                };

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

                input = {
                    focus = {
                        follows_mouse = "always";
                        follows_mouse_max_scroll = 0.0;
                        hover_raises = false;
                    };
                };

                layout = {
                    mode = "dwindle";
                    gap = 8;
                    dwindle = {
                        new_toward_cursor = false;
                        preserve_split = true;
                    };
                };

                output = {
                    "*" = {
                        scale = 1.0;
                        vrr = "fullscreen";
                        workspaces = 10;
                        #min_workspaces = 10;
                        workspace_axis = "vertical";
                    };
                };

                keybinds = {
                    # --- Core Applications & Noctalia Shell ---
                    "Mod+R" = "spawn noctalia msg panel-toggle launcher";
                    "Mod+T" = "spawn kitty";
                    "Mod+E" = "spawn nautilus";
                    "Mod+B" = "spawn firefox";
                    "Mod+Escape" = "spawn noctalia msg panel-toggle session-menu";
                    "Mod+N" = "spawn noctalia msg panel-toggle control-center";
                    "Mod+Shift+L" = "spawn noctalia msg lock";

                    # --- Window Management ---
                    "Mod+Q" = "window-close";
                    "Mod+F" = "window-toggle-fullscreen";
                    "Mod+V" = "window-toggle-floating";
                    "Mod+C" = "window-center";

                    # --- Focus Movement ---
                    "Mod+Left" = "window-focus-left";
                    "Mod+Down" = "window-focus-down";
                    "Mod+Up" = "window-focus-up";
                    "Mod+Right" = "window-focus-right";

                    # --- Move / Swap Windows ---
                    "Mod+Shift+Left" = "window-move-left";
                    "Mod+Shift+Down" = "window-move-down";
                    "Mod+Shift+Up" = "window-move-up";
                    "Mod+Shift+Right" = "window-move-right";

                    # --- Move Window to Next/Previous Workspace ---
                    "Mod+Ctrl+Down" = "window-move-to-workspace-next";
                    "Mod+Ctrl+Right" = "window-move-to-workspace-next";
                    "Mod+Ctrl+Up" = "window-move-to-workspace-previous";
                    "Mod+Ctrl+Left" = "window-move-to-workspace-previous";

                    # --- Workspaces (Explicit 1-10) ---
                    "Mod+1" = "workspace-switch 1";
                    "Mod+2" = "workspace-switch 2";
                    "Mod+3" = "workspace-switch 3";
                    "Mod+4" = "workspace-switch 4";
                    "Mod+5" = "workspace-switch 5";
                    "Mod+6" = "workspace-switch 6";
                    "Mod+7" = "workspace-switch 7";
                    "Mod+8" = "workspace-switch 8";
                    "Mod+9" = "workspace-switch 9";
                    "Mod+0" = "workspace-switch 10";

                    # --- Move Window to Workspace (Explicit 1-10) ---
                    "Mod+Shift+1" = "window-move-to-workspace 1";
                    "Mod+Shift+2" = "window-move-to-workspace 2";
                    "Mod+Shift+3" = "window-move-to-workspace 3";
                    "Mod+Shift+4" = "window-move-to-workspace 4";
                    "Mod+Shift+5" = "window-move-to-workspace 5";
                    "Mod+Shift+6" = "window-move-to-workspace 6";
                    "Mod+Shift+7" = "window-move-to-workspace 7";
                    "Mod+Shift+8" = "window-move-to-workspace 8";
                    "Mod+Shift+9" = "window-move-to-workspace 9";
                    "Mod+Shift+0" = "window-move-to-workspace 10";

                    # --- Cycle Workspaces & Monitors ---
                    "Mod+Page_Down" = "workspace-next";
                    "Mod+Page_Up" = "workspace-previous";
                    "Mod+Comma" = "output-focus-previous";
                    "Mod+Period" = "output-focus-next";
                    "Mod+Shift+Comma" = "window-move-to-output-previous";
                    "Mod+Shift+Period" = "window-move-to-output-next";

                    # --- Hardware Keys: Audio & Media ---
                    "XF86AudioRaiseVolume" = "spawn wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
                    "XF86AudioLowerVolume" = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
                    "XF86AudioMute" = "spawn wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                    "XF86AudioMicMute" = "spawn wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
                    "XF86AudioPlay" = "spawn playerctl play-pause";
                    "XF86AudioPause" = "spawn playerctl play-pause";
                    "XF86AudioNext" = "spawn playerctl next";
                    "XF86AudioPrev" = "spawn playerctl previous";

                    # --- Hardware Keys: Screen & Keyboard Backlight ---
                    "XF86MonBrightnessUp" = "spawn brightnessctl set +5%";
                    "XF86MonBrightnessDown" = "spawn brightnessctl set 5%-";
                    "XF86KbdBrightnessUp" = "spawn brightnessctl --device='*::kbd_backlight' set +10%";
                    "XF86KbdBrightnessDown" = "spawn brightnessctl --device='*::kbd_backlight' set 10%-";

                    # --- Screenshots ---
                    # "Mod+P" = "spawn sh -c 'grim -g \"$(slurp)\" | wl-copy'";
                    # "Mod+Shift+P" = "spawn sh -c 'grim | wl-copy'";
                    "Mod+P" = "spawn noctalia msg screenshot-region --no-annotate";
                    "Mod+Shift+P" = "spawn noctalia msg screenshot-region --annotate";

                    # --- Compositor Session ---
                    "Mod+Slash" = "cheatsheet-toggle";
                };

            };
        };

    };
}