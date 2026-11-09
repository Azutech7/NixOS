{ inputs, config, lib, pkgs, ... }: {

    # OPTIONS BLOCK
    options.modules.theme = {
        enable = lib.mkEnableOption "theme";

        color = {
            background = lib.mkOption { type = lib.types.str; };
            br_background = lib.mkOption { type = lib.types.str; };
            foreground = lib.mkOption { type = lib.types.str; };
            cursor = lib.mkOption { type = lib.types.str; };
            selection = lib.mkOption { type = lib.types.str; };
            comment = lib.mkOption { type = lib.types.str; };

            primary = lib.mkOption { type = lib.types.str; };
            secondary = lib.mkOption { type = lib.types.str; };
            tertiary = lib.mkOption { type = lib.types.str; };
            quaternary = lib.mkOption { type = lib.types.str; };

            red = lib.mkOption { type = lib.types.str; };
            orange = lib.mkOption { type = lib.types.str; };
            yellow = lib.mkOption { type = lib.types.str; };
            green = lib.mkOption { type = lib.types.str; };
            cyan = lib.mkOption { type = lib.types.str; };
            blue = lib.mkOption { type = lib.types.str; };
            magenta = lib.mkOption { type = lib.types.str; };
            violet = lib.mkOption { type = lib.types.str; };

            br_red = lib.mkOption { type = lib.types.str; };
            br_orange = lib.mkOption { type = lib.types.str; };
            br_yellow = lib.mkOption { type = lib.types.str; };
            br_green = lib.mkOption { type = lib.types.str; };
            br_cyan = lib.mkOption { type = lib.types.str; };
            br_blue = lib.mkOption { type = lib.types.str; };
            br_magenta = lib.mkOption { type = lib.types.str; };
            br_violet = lib.mkOption { type = lib.types.str; };

            error = lib.mkOption { type = lib.types.str; };
            warning = lib.mkOption { type = lib.types.str; };
            string = lib.mkOption { type = lib.types.str; };
            number = lib.mkOption { type = lib.types.str; };
            boolean = lib.mkOption { type = lib.types.str; };
            class = lib.mkOption { type = lib.types.str; };
            function = lib.mkOption { type = lib.types.str; };
            character = lib.mkOption { type = lib.types.str; };
        };

        image = {
            wallpaper = lib.mkOption { type = lib.types.path; };
            sys-tray-icon = lib.mkOption { type = lib.types.path; };
            fetch-icon = lib.mkOption { type = lib.types.path; };
        };

        font = {
            package = lib.mkOption { type = lib.types.package; };
            name = lib.mkOption { type = lib.types.str; };
            size = {
                default = lib.mkOption { type = lib.types.int; };
                terminal = lib.mkOption { type = lib.types.int; };
                desktop = lib.mkOption { type = lib.types.int; };
                popups = lib.mkOption { type = lib.types.int; };
                applications = lib.mkOption { type = lib.types.int; };
            };
        };

        cursor = {
            package = lib.mkOption { type = lib.types.package; };
            name = lib.mkOption { type = lib.types.str; };
            size = lib.mkOption { type = lib.types.int; };
        };
    };

    # CONFIGURATION BLOCK
    config = lib.mkIf config.modules.theme.enable (
        let
            cfg = config.modules.theme;
        in
        {
            modules.theme = {
                color = {
                    error = lib.mkDefault cfg.color.red;
                    warning = lib.mkDefault cfg.color.yellow;
                    string = lib.mkDefault cfg.color.green;
                    number = lib.mkDefault cfg.color.blue;
                    boolean = lib.mkDefault cfg.color.magenta;
                    class = lib.mkDefault cfg.color.orange;
                    function = lib.mkDefault cfg.color.cyan;
                    character = lib.mkDefault cfg.color.violet;
                };

                font = {
                    size = {
                        terminal = lib.mkDefault cfg.font.size.default;
                        desktop = lib.mkDefault cfg.font.size.default;
                        popups = lib.mkDefault cfg.font.size.default;
                        applications = lib.mkDefault cfg.font.size.default;
                    };
                };
            };

            fonts.fontconfig.enable = true;

            home.packages = with pkgs; [
                cfg.font.package
            ];

            home.sessionVariables = {
                XCURSOR_THEME = cfg.cursor.name;
                XCURSOR_SIZE = cfg.cursor.size;
                HYPRCURSOR_THEME = cfg.cursor.name;
                HYPRCURSOR_SIZE = cfg.cursor.size;
            };

            home.pointerCursor = {
                package = cfg.cursor.package;
                name = cfg.cursor.name;
                size = cfg.cursor.size;
                gtk.enable = true;
                x11.enable = true;
            };

            gtk = {
                enable = true;
                cursorTheme = {
                    package = cfg.cursor.package;
                    name = cfg.cursor.name;
                };
                gtk4.theme = null;
            };
        }
    );
}
