{ inputs, config, lib, pkgs, ... }: {

    options.modules.environment.noctalia = {
        enable = lib.mkEnableOption "environment.noctalia";

        umbriel-support.enable = lib.mkEnableOption "environment.noctalia.umbriel-support";

        theme-support.enable = lib.mkEnableOption "environment.noctalia.theme-support";

        check-config = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "environment.noctalia.check-config";
        };
    };

    config = lib.mkIf config.modules.environment.noctalia.enable (

        lib.mkMerge [
            {
                programs.noctalia.enable = true;
            }

            (lib.mkIf config.modules.environment.umbriel.enable {
                modules.environment.noctalia.umbriel-support.enable = lib.mkDefault true;
            })

            (lib.mkIf config.modules.environment.noctalia.umbriel-support.enable {
                programs.noctalia.settings.theme.templates = {
                    enable_builtin_templates = true;
                    builtin_ids = [ "umbriel" ];
                };
            })

            (lib.mkIf config.modules.theme.enable {
                modules.environment.noctalia.theme-support.enable = lib.mkDefault true;
            })

            (lib.mkIf config.modules.environment.noctalia.theme-support.enable {
                programs.noctalia = {
                    settings = {
                        wallpaper = {
                            enabled = true;
                            default.path = config.modules.theme.image.wallpaper;
                            fill_mode = "fit";
                        };

                        theme = {
                            mode = "dark";
                            shell_mode = "follow";
                            source = "custom";
                            custom_palette = "managed-theme";
                            sync_color_scheme = true;
                        };
                    };

                    customPalettes."managed-theme" = {
                        version = 2;
                        dark = {
                            primary = "#${config.modules.theme.color.primary}";
                            on_primary = "#${config.modules.theme.color.background}";
                            secondary = "#${config.modules.theme.color.primary}";
                            on_secondary = "#${config.modules.theme.color.background}";
                            tertiary = "#${config.modules.theme.color.primary}";
                            on_tertiary = "#${config.modules.theme.color.foreground}";
                            error = "#${config.modules.theme.color.error}";
                            on_error = "#${config.modules.theme.color.background}";
                            surface = "#${config.modules.theme.color.background}";
                            on_surface = "#${config.modules.theme.color.foreground}";
                            surface_container = "#${config.modules.theme.color.background}";
                            on_surface_variant = "#${config.modules.theme.color.foreground}";
                            outline_variant = "#${config.modules.theme.color.comment}";
                            shadow = "#${config.modules.theme.color.background}";
                            hover = "#${config.modules.theme.color.primary}";
                            on_hover = "#${config.modules.theme.color.foreground}";
                            terminal = {
                                normal = {
                                    black = "#${config.modules.theme.color.background}";
                                    red = "#${config.modules.theme.color.error}";
                                    green = "#${config.modules.theme.color.primary}";
                                    yellow = "#${config.modules.theme.color.primary}";
                                    blue = "#${config.modules.theme.color.primary}";
                                    magenta = "#${config.modules.theme.color.primary}";
                                    cyan = "#${config.modules.theme.color.primary}";
                                    white = "#${config.modules.theme.color.foreground}";
                                };
                                bright = {
                                    black = "#${config.modules.theme.color.comment}";
                                    red = "#${config.modules.theme.color.error}";
                                    green = "#${config.modules.theme.color.primary}";
                                    yellow = "#${config.modules.theme.color.primary}";
                                    blue = "#${config.modules.theme.color.primary}";
                                    magenta = "#${config.modules.theme.color.primary}";
                                    cyan = "#${config.modules.theme.color.primary}";
                                    white = "#${config.modules.theme.color.foreground}";
                                };
                                foreground = "#${config.modules.theme.color.foreground}";
                                background = "#${config.modules.theme.color.background}";
                                selection_fg = "#${config.modules.theme.color.foreground}";
                                selection_bg = "#${config.modules.theme.color.selection}";
                                cursor_text = "#${config.modules.theme.color.background}";
                                cursor = "#${config.modules.theme.color.primary}";
                            };
                        };
                        light = {
                            primary = "#${config.modules.theme.color.primary}";
                            on_primary = "#${config.modules.theme.color.background}";
                            secondary = "#${config.modules.theme.color.primary}";
                            on_secondary = "#${config.modules.theme.color.background}";
                            tertiary = "#${config.modules.theme.color.primary}";
                            on_tertiary = "#${config.modules.theme.color.foreground}";
                            error = "#${config.modules.theme.color.error}";
                            on_error = "#${config.modules.theme.color.background}";
                            surface = "#${config.modules.theme.color.background}";
                            on_surface = "#${config.modules.theme.color.foreground}";
                            surface_container = "#${config.modules.theme.color.background}";
                            on_surface_variant = "#${config.modules.theme.color.foreground}";
                            outline_variant = "#${config.modules.theme.color.comment}";
                            shadow = "#${config.modules.theme.color.background}";
                            hover = "#${config.modules.theme.color.primary}";
                            on_hover = "#${config.modules.theme.color.foreground}";
                            terminal = {
                                normal = {
                                    black = "#${config.modules.theme.color.background}";
                                    red = "#${config.modules.theme.color.error}";
                                    green = "#${config.modules.theme.color.primary}";
                                    yellow = "#${config.modules.theme.color.primary}";
                                    blue = "#${config.modules.theme.color.primary}";
                                    magenta = "#${config.modules.theme.color.primary}";
                                    cyan = "#${config.modules.theme.color.primary}";
                                    white = "#${config.modules.theme.color.foreground}";
                                };
                                bright = {
                                    black = "#${config.modules.theme.color.comment}";
                                    red = "#${config.modules.theme.color.error}";
                                    green = "#${config.modules.theme.color.primary}";
                                    yellow = "#${config.modules.theme.color.primary}";
                                    blue = "#${config.modules.theme.color.primary}";
                                    magenta = "#${config.modules.theme.color.primary}";
                                    cyan = "#${config.modules.theme.color.primary}";
                                    white = "#${config.modules.theme.color.foreground}";
                                };
                                foreground = "#${config.modules.theme.color.foreground}";
                                background = "#${config.modules.theme.color.background}";
                                selection_fg = "#${config.modules.theme.color.foreground}";
                                selection_bg = "#${config.modules.theme.color.selection}";
                                cursor_text = "#${config.modules.theme.color.background}";
                                cursor = "#${config.modules.theme.color.primary}";
                            };
                        };
                    };
                };
            })

            (lib.mkIf config.modules.environment.noctalia.check-config {
                programs.noctalia.checkConfig = true;
            })
        ]

    );
}