{ inputs, config, pkgs, lib, ... }:

let
    theme = config.modules.theme;
    c = theme.color;

    # =========================================================================
    # NON-THEME INTEGER SETTINGS (CHECK THESE VALUES)
    # =========================================================================

    # Corner Radii (px)
    radius0  = 0; # CHECK THIS
    radiusXs = 2; # CHECK THIS
    radiusS  = 8; # CHECK THIS
    radiusM  = 8; # CHECK THIS
    radiusL  = 8; # CHECK THIS
    radiusXl = 8; # CHECK THIS

    # Spacing Scale (px)
    spaceNone = 0;  # CHECK THIS
    spaceXxxs = 4;  # CHECK THIS
    spaceXxs  = 4;  # CHECK THIS
    spaceXs   = 8;  # CHECK THIS
    spaceS    = 8;  # CHECK THIS
    spaceM    = 16; # CHECK THIS
    spaceL    = 24; # CHECK THIS
    spaceXl   = 32; # CHECK THIS
    spaceXxl  = 48; # CHECK THIS
    spaceXxxl = 64; # CHECK THIS

    # Window Gaps & Active Window Border Thickness (px)
    # gapOuter   = 0;  # CHECK THIS
    gapInner   = 16; # CHECK THIS
    activeHint = 2;  # CHECK THIS

    # =========================================================================
    # NON-THEME NON-INTEGER SETTINGS (ENUMS, BOOLEANS, FLOATS)
    # =========================================================================

    # Note: `frosted` uses a RON enum identifier, NOT an integer.
    # Valid values: "Off" | "Low" | "Medium" | "High"
    frosted = "Off"; # CHECK THIS

    # Note: `frosted_*` flags use RON booleans ("true" | "false"), NOT integers.
    frostedWindows         = "false"; # CHECK THIS
    frostedSystemInterface = "false"; # CHECK THIS
    frostedPanel           = "false"; # CHECK THIS
    frostedApplets         = "false"; # CHECK THIS
    frostedMaximizedApps   = "false"; # CHECK THIS

    # Note: `alpha_map` uses 0.0–1.0 floats for frosted glass transparency steps, NOT integers.
    alphaExtremelyLow   = "0.9";     # CHECK THIS
    alphaExtremelyLow2  = "0.87692"; # CHECK THIS
    alphaVeryLow        = "0.85385"; # CHECK THIS
    alphaVeryLow2       = "0.83076"; # CHECK THIS
    alphaLow            = "0.80769"; # CHECK THIS
    alphaLow2           = "0.78461"; # CHECK THIS
    alphaMedium         = "0.76154"; # CHECK THIS
    alphaMedium2        = "0.73846"; # CHECK THIS
    alphaHigh           = "0.71538"; # CHECK THIS
    alphaHigh2          = "0.69231"; # CHECK THIS
    alphaVeryHigh       = "0.66023"; # CHECK THIS
    alphaVeryHigh2      = "0.64615"; # CHECK THIS
    alphaExtremelyHigh  = "0.62308"; # CHECK THIS
    alphaExtremelyHigh2 = "0.6";     # CHECK THIS

    # =========================================================================
    # HELPERS
    # =========================================================================

    # Format "#RRGGBB" or "RRGGBB" -> "#RRGGBBFF" for COSMIC ThemeBuilder RON strings
    hex8 = hex: "#${lib.toUpper (lib.removePrefix "#" hex)}FF";

    # Format integer radius -> COSMIC's 4-corner float tuple "(r.0, r.0, r.0, r.0)"
    mkRadius = r:
        let f = "${toString r}.0";
        in "(${f}, ${f}, ${f}, ${f})";

    # =========================================================================
    # FULL DARK THEME BUILDER ENTRIES
    # =========================================================================

    builderEntries = {
        # --- Core Colors (Tied to modules.theme.color) ---
        "accent".text                 = ''Some("${hex8 c.primary}")'';
        "window_hint".text            = ''Some("${hex8 c.primary}")'';
        "bg_color".text               = ''Some("${hex8 c.background}")'';
        "primary_container_bg".text   = ''Some("${hex8 c.br_background}")'';
        "secondary_container_bg".text = ''Some("${hex8 c.selection}")'';
        "text_tint".text              = ''Some("${hex8 c.foreground}")'';
        "neutral_tint".text           = ''Some("${hex8 c.comment}")'';
        "success".text                = ''Some("${hex8 c.green}")'';
        "warning".text                = ''Some("${hex8 c.warning}")'';
        "destructive".text            = ''Some("${hex8 c.error}")'';

        # --- Full Palette (Replaces all default COSMIC swatches, greens, oranges, etc.) ---
        "palette".text = ''
            Dark((
                name: "custom-dark",
                bright_red: "${hex8 c.br_red}",
                bright_green: "${hex8 c.br_green}",
                bright_orange: "${hex8 c.br_orange}",
                gray_1: "${hex8 c.br_background}",
                gray_2: "${hex8 c.selection}",
                neutral_0: "${hex8 c.background}",
                neutral_1: "${hex8 c.background}",
                neutral_2: "${hex8 c.br_background}",
                neutral_3: "${hex8 c.selection}",
                neutral_4: "${hex8 c.comment}",
                neutral_5: "${hex8 c.comment}",
                neutral_6: "${hex8 c.comment}",
                neutral_7: "${hex8 c.foreground}",
                neutral_8: "${hex8 c.foreground}",
                neutral_9: "${hex8 c.foreground}",
                neutral_10: "${hex8 c.foreground}",
                accent_blue: "${hex8 c.blue}",
                accent_indigo: "${hex8 c.violet}",
                accent_purple: "${hex8 c.magenta}",
                accent_pink: "${hex8 c.br_magenta}",
                accent_red: "${hex8 c.red}",
                accent_orange: "${hex8 c.orange}",
                accent_yellow: "${hex8 c.yellow}",
                accent_green: "${hex8 c.green}",
                accent_warm_grey: "${hex8 c.comment}",
                ext_warm_grey: "${hex8 c.comment}",
                ext_orange: "${hex8 c.br_orange}",
                ext_yellow: "${hex8 c.br_yellow}",
                ext_blue: "${hex8 c.br_blue}",
                ext_purple: "${hex8 c.br_violet}",
                ext_pink: "${hex8 c.br_magenta}",
                ext_indigo: "${hex8 c.cyan}",
            ))
        '';

        # --- Spacing & Corner Radii ---
        "spacing".text = ''
            (
                space_none: ${toString spaceNone},
                space_xxxs: ${toString spaceXxxs},
                space_xxs: ${toString spaceXxs},
                space_xs: ${toString spaceXs},
                space_s: ${toString spaceS},
                space_m: ${toString spaceM},
                space_l: ${toString spaceL},
                space_xl: ${toString spaceXl},
                space_xxl: ${toString spaceXxl},
                space_xxxl: ${toString spaceXxxl},
            )
        '';

        "corner_radii".text = ''
            (
                radius_0: ${mkRadius radius0},
                radius_xs: ${mkRadius radiusXs},
                radius_s: ${mkRadius radiusS},
                radius_m: ${mkRadius radiusM},
                radius_l: ${mkRadius radiusL},
                radius_xl: ${mkRadius radiusXl},
            )
        '';

        # --- Gaps, Hints & Frosted Glass ---
        "gaps".text                     = "(${toString gapOuter}, ${toString gapInner})";
        "active_hint".text              = "${toString activeHint}";
        "frosted".text                  = frosted;
        "frosted_windows".text          = frostedWindows;
        "frosted_system_interface".text = frostedSystemInterface;
        "frosted_panel".text            = frostedPanel;
        "frosted_applets".text          = frostedApplets;
        "frosted_maximized_apps".text   = frostedMaximizedApps;

        # --- Alpha Map ---
        "alpha_map".text = ''
            (
                extremely_low: ${alphaExtremelyLow},
                extremely_low_2: ${alphaExtremelyLow2},
                very_low: ${alphaVeryLow},
                very_low_2: ${alphaVeryLow2},
                low: ${alphaLow},
                low_2: ${alphaLow2},
                medium: ${alphaMedium},
                medium_2: ${alphaMedium2},
                high: ${alphaHigh},
                high_2: ${alphaHigh2},
                very_high: ${alphaVeryHigh},
                very_high_2: ${alphaVeryHigh2},
                extremely_high: ${alphaExtremelyHigh},
                extremely_high_2: ${alphaExtremelyHigh2},
            )
        '';
    };

    prefixBuilder = prefix:
        lib.mapAttrs' (name: val: lib.nameValuePair "${prefix}/${name}" val) builderEntries;
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
                xdg.configFile = {
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

                #### COLORS & BUILDER ####
                // (prefixBuilder "cosmic/com.system76.CosmicTheme.Dark.Builder/v1")
                // (prefixBuilder "cosmic/com.system76.CosmicTheme.Dark.Builder/v2");

                home.activation.reloadCosmicTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                    if ${pkgs.procps}/bin/pgrep -x cosmic-settings-daemon >/dev/null; then
                        ${pkgs.procps}/bin/pkill -x cosmic-settings-daemon || true
                        ${pkgs.util-linux}/bin/setsid -f cosmic-settings-daemon >/dev/null 2>&1 || true
                    fi
                '';
            })
        ]
    );
}