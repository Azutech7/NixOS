{ inputs, config, pkgs, lib, ... }:

let
    theme = config.modules.theme;
    c = theme.color;

    # Pure-Nix Hex -> COSMIC Srgba helpers
    hexPairToInt = hex:
        let
            chars = lib.stringToCharacters (lib.toLower hex);
            hexMap = {
                "0" = 0; "1" = 1; "2" = 2; "3" = 3;
                "4" = 4; "5" = 5; "6" = 6; "7" = 7;
                "8" = 8; "9" = 9; "a" = 10; "b" = 11;
                "c" = 12; "d" = 13; "e" = 14; "f" = 15;
            };
        in
        (hexMap.${builtins.elemAt chars 0} * 16) + hexMap.${builtins.elemAt chars 1};

    rgba = hex: alpha:
        let
            cleanHex = lib.removePrefix "#" hex;
            r = (hexPairToInt (builtins.substring 0 2 cleanHex)) / 255.0;
            g = (hexPairToInt (builtins.substring 2 2 cleanHex)) / 255.0;
            b = (hexPairToInt (builtins.substring 4 2 cleanHex)) / 255.0;
        in
        ''
            (
                red: ${toString r},
                green: ${toString g},
                blue: ${toString b},
                alpha: ${toString alpha},
            )
        '';

    rgb = hex: rgba hex 1.0;

    # Reusable container block with corrected `disabled_border` field name
    mkContainer = { base, compBase, compHover, compPressed }: ''
        (
            base: ${rgb base},
            on: ${rgb c.foreground},
            divider: ${rgba c.comment 0.35},
            component: (
                base: ${rgb compBase},
                hover: ${rgb compHover},
                pressed: ${rgb compPressed},
                selected: ${rgb c.selection},
                selected_text: ${rgb c.br_blue},
                focus: ${rgb c.br_blue},
                divider: ${rgba c.comment 0.35},
                on: ${rgb c.foreground},
                on_disabled: ${rgba c.comment 0.6},
                disabled: ${rgba compBase 0.5},
                border: ${rgb c.comment},
                disabled_border: ${rgba c.comment 0.4},
            ),
        )
    '';

    # Core GUI-level theme colors
    coreColors = {
        "accent".text = rgb c.blue;
        "success".text = rgb c.green;
        "warning".text = rgb c.warning;
        "destructive".text = rgb c.error;
        "window_header_background".text = rgb c.background;

        "background".text = mkContainer {
            base = c.background;
            compBase = c.br_background;
            compHover = c.primary;
            compPressed = c.selection;
        };

        "primary".text = mkContainer {
            base = c.primary;
            compBase = c.br_background;
            compHover = c.selection;
            compPressed = c.selection;
        };

        "secondary".text = mkContainer {
            base = c.br_background;
            compBase = c.primary;
            compHover = c.selection;
            compPressed = c.selection;
        };
    };

    prefixTheme = prefix:
        lib.mapAttrs' (name: val: lib.nameValuePair "${prefix}/${name}" val) coreColors;
in
{
    options.modules.environment.cosmic = {
        enable = lib.mkEnableOption "environment.cosmic";
        
        theme-support.enable = lib.mkEnableOption "environment.cosmic.theme-support";
    };

    config = lib.mkIf config.modules.environment.cosmic.enable (
        lib.mkMerge [
            {
                # Default would go here
            }

            (lib.mkIf config.modules.theme.enable {
                modules.environment.cosmic.theme-support.enable = lib.mkDefault true;
            })

            (lib.mkIf config.modules.environment.cosmic.theme-support.enable {
                xdg.configFile =
                    {
                        #### FONT ####
                        "cosmic/com.system76.CosmicTk/v1/interface_font".text = ''
                            (
                                family: "${theme.font.name}",
                                weight: Normal, 
                                stretch: Normal,
                                style: Normal,
                            )
                        '';
                        "cosmic/com.system76.CosmicTk/v1/monospace_font".text = ''
                            (
                                family: "${theme.font.name}",
                                weight: Normal, 
                                stretch: Normal,
                                style: Normal,
                            )
                        '';

                        #### WALLPAPER ####
                        "cosmic/com.system76.CosmicBackground/v1/same-on-all".text = "true";    
                        "cosmic/com.system76.CosmicBackground/v1/all".text = ''
                            (
                                filter_by_theme: false,
                                filter_method: Lanczos,
                                output: "all",
                                rotation_frequency: 300,
                                sampling_method: Alphanumeric,
                                scaling_mode: Zoom,
                                source: Path("${theme.image.wallpaper}"),
                            )
                        '';

                        #### MODE ####
                        "cosmic/com.system76.CosmicTheme.Mode/v1/is_dark".text = "true";
                    }
                    #### COLORS ####
                    // (prefixTheme "cosmic/com.system76.CosmicTheme.Dark/v1")
                    // (prefixTheme "cosmic/com.system76.CosmicTheme.Dark/v2");
            })
        ]
    );
}
