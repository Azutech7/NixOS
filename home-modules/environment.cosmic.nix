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

    # Flat Builder colors (mirrors COSMIC Settings -> Appearance)
    builderColors = {
        "accent".text = "Some(${rgb c.blue})";
        "bg_color".text = "Some(${rgb c.background})";
        "primary_container_bg".text = "Some(${rgb c.primary})";
        "secondary_container_bg".text = "Some(${rgb c.br_background})";
        "text_tint".text = "Some(${rgb c.foreground})";
        "neutral_tint".text = "Some(${rgb c.comment})";
        "success".text = "Some(${rgb c.green})";
        "warning".text = "Some(${rgb c.warning})";
        "destructive".text = "Some(${rgb c.error})";
    };

    prefixBuilder = prefix:
        lib.mapAttrs' (name: val: lib.nameValuePair "${prefix}/${name}" val) builderColors;
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
                    // (prefixBuilder "cosmic/com.system76.CosmicTheme.Dark.Builder/v1");
            })
        ]
    );
}
