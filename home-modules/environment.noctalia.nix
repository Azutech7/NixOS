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
                programs.noctalia.settings."theme.templates" = {
                    enable_builtin_templates = true;
                    builtin_ids = [ "umbriel" ];
                };
            })

            (lib.mkIf config.modules.theme.enable {
                modules.environment.noctalia.theme-support.enable = lib.mkDefault true;
            })

            (lib.mkIf config.modules.environment.theme-support.enable {
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

                        customPalettes."managed-theme" = { # Replace with custom colors later
                            name = "managed-theme";
                            dark = {
                                primary = "#7aa2f7";
                                on_primary = "#1a1b26";
                                primary_container = "#283457";
                                on_primary_container = "#c0caf5";

                                secondary = "#bb9af7";
                                on_secondary = "#1a1b26";
                                secondary_container = "#3b2e58";
                                on_secondary_container = "#e0af68";

                                tertiary = "#7dcfff";
                                on_tertiary = "#1a1b26";
                                tertiary_container = "#223b4d";
                                on_tertiary_container = "#b4f9f8";

                                error = "#f7768e";
                                on_error = "#1a1b26";
                                error_container = "#4c222b";
                                on_error_container = "#ff9e64";

                                background = "#16161e";
                                on_background = "#c0caf5";
                                surface = "#1a1b26";
                                on_surface = "#c0caf5";
                                surface_variant = "#24283b";
                                on_surface_variant = "#a9b1d6";

                                surface_container_lowest = "#13131a";
                                surface_container_low = "#1a1b26";
                                surface_container = "#1f2335";
                                surface_container_high = "#292e42";
                                surface_container_highest = "#343b58";

                                outline = "#565f89";
                                outline_variant = "#3b4261";
                                shadow = "#000000";
                                scrim = "#000000";
                                inverse_surface = "#c0caf5";
                                inverse_on_surface = "#1a1b26";
                                inverse_primary = "#3d59a1";
                            };
                        };
                    };
                };
            })

            (lib.mkIf config.modules.environment.check-config {
                programs.noctalia.checkConfig = true;
            })
        ]

    );
}
