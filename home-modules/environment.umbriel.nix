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

                output = {
                    "*" = {
                        scale = 1.0;
                        vrr = "fullscreen";
                        workspaces = "dynamic";
                        min_workspaces = 10;
                        workspace_axis = "vertical";
                        layout = {
                            mode = "dwindle";
                        };
                    };
                };

                keybinds = {
                    # --- Core Applications & Noctalia Shell ---
                    "Mod+R" = "spawn noctalia msg panel-toggle launcher";
                    "Mod+T" = "spawn kitty";
                    "Mod+E" = "spawn nautilus"; # Or your preferred file manager (e.g., thunar, dolphin)
                    "Mod+B" = "spawn firefox";
                    "Mod+Escape" = "spawn noctalia msg panel-toggle session-menu"; # Power / lock / logout menu
                    "Mod+N" = "spawn noctalia msg panel-toggle control-center"; # Quick settings / notifications
                    "Mod+Shift+L" = "spawn noctalia msg lock"; # Lock screen immediately

                    # --- Window Management ---
                    "Mod+Q" = "window-close";
                    "Mod+F" = "window-toggle-fullscreen";
                    "Mod+V" = "window-toggle-floating";
                    "Mod+P" = "window-pin"; # Keep floating window sticky across workspaces
                    "Mod+C" = "window-center"; # Center floating window on screen

                    # --- Focus Movement (Arrows + Vim keys) ---
                    "Mod+Left" = "window-focus-left";
                    "Mod+Down" = "window-focus-down";
                    "Mod+Up" = "window-focus-up";
                    "Mod+Right" = "window-focus-right";
                    "Mod+H" = "window-focus-left";
                    "Mod+J" = "window-focus-down";
                    "Mod+K" = "window-focus-up";
                    "Mod+L" = "window-focus-right";

                    # --- Move / Swap Windows ---
                    "Mod+Shift+Left" = "window-move-left";
                    "Mod+Shift+Down" = "window-move-down";
                    "Mod+Shift+Up" = "window-move-up";
                    "Mod+Shift+Right" = "window-move-right";
                    "Mod+Shift+H" = "window-move-left";
                    "Mod+Shift+J" = "window-move-down";
                    "Mod+Shift+K" = "window-move-up";
                    "Mod+Shift+L" = "window-move-right";

                    # --- Resize Windows ---
                    "Mod+Ctrl+Left" = "window-resize-width -5%";
                    "Mod+Ctrl+Right" = "window-resize-width +5%";
                    "Mod+Ctrl+Up" = "window-resize-height -5%";
                    "Mod+Ctrl+Down" = "window-resize-height +5%";

                    # --- Workspaces (Explicit 1-10) ---
                    "Mod+1" = "workspace-focus 1";
                    "Mod+2" = "workspace-focus 2";
                    "Mod+3" = "workspace-focus 3";
                    "Mod+4" = "workspace-focus 4";
                    "Mod+5" = "workspace-focus 5";
                    "Mod+6" = "workspace-focus 6";
                    "Mod+7" = "workspace-focus 7";
                    "Mod+8" = "workspace-focus 8";
                    "Mod+9" = "workspace-focus 9";
                    "Mod+0" = "workspace-focus 10";

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
                    "Mod+Page_Down" = "workspace-focus-next";
                    "Mod+Page_Up" = "workspace-focus-prev";
                    "Mod+Tab" = "workspace-focus-previous"; # Toggle back and forth between last two workspaces
                    "Mod+Comma" = "output-focus-prev";
                    "Mod+Period" = "output-focus-next";
                    "Mod+Shift+Comma" = "window-move-to-output-prev";
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

                    # --- Screenshots (Wayland: grim + slurp + wl-copy) ---
                    "Print" = "spawn sh -c 'grim -g \"$(slurp)\" - | wl-copy'";
                    "Shift+Print" = "spawn sh -c 'grim - | wl-copy'";
                    "Mod+Shift+S" = "spawn sh -c 'grim -g \"$(slurp)\" - | wl-copy'";

                    # --- Compositor Session ---
                    "Mod+Shift+E" = "quit";
                    "Mod+Slash" = "cheatsheet-toggle"; # Since you have show_cheatsheet = true
                };

            };
        };

    };
}