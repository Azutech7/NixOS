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
                        name = "managed-theme";
                        dark = {
                            primary = "#${config.modules.theme.color.primary}";
                            on_primary = "#${config.modules.theme.color.background}";
                            primary_container = "#${config.modules.theme.color.primary}";
                            on_primary_container = "#${config.modules.theme.color.foreground}";

                            secondary = "#${config.modules.theme.color.primary}";
                            on_secondary = "#${config.modules.theme.color.background}";
                            secondary_container = "#${config.modules.theme.color.primary}";
                            on_secondary_container = "#${config.modules.theme.color.primary}";

                            tertiary = "#${config.modules.theme.color.primary}";
                            on_tertiary = "#${config.modules.theme.color.background}";
                            tertiary_container = "#${config.modules.theme.color.primary}";
                            on_tertiary_container = "#${config.modules.theme.color.primary}";

                            error = "#${config.modules.theme.color.error}";
                            on_error = "#${config.modules.theme.color.background}";
                            error_container = "#${config.modules.theme.color.error}";
                            on_error_container = "#${config.modules.theme.color.error}";

                            background = "#${config.modules.theme.color.background}";
                            on_background = "#${config.modules.theme.color.foreground}";
                            surface = "#${config.modules.theme.color.background}";
                            on_surface = "#${config.modules.theme.color.foreground}";
                            surface_variant = "#${config.modules.theme.color.selection}";
                            on_surface_variant = "#${config.modules.theme.color.foreground}";

                            surface_container_lowest = "#${config.modules.theme.color.background}";
                            surface_container_low = "#${config.modules.theme.color.background}";
                            surface_container = "#${config.modules.theme.color.background}";
                            surface_container_high = "#${config.modules.theme.color.selection}";
                            surface_container_highest = "#${config.modules.theme.color.selection}";

                            outline = "#${config.modules.theme.color.comment}";
                            outline_variant = "#${config.modules.theme.color.comment}";
                            shadow = "#${config.modules.theme.color.background}";
                            scrim = "#${config.modules.theme.color.background}";
                            inverse_surface = "#${config.modules.theme.color.foreground}";
                            inverse_on_surface = "#${config.modules.theme.color.background}";
                            inverse_primary = "#${config.modules.theme.color.primary}";
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