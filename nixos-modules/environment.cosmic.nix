{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.environment.cosmic = {
        enable = lib.mkEnableOption "environment.cosmic";

        make-default = lib.mkEnableOption "environment.cosmic.make-default";

        greeter.enable = lib.mkEnableOption "environment.cosmic.greeter";

        nvidia-fixes.enable = lib.mkEnableOption "environment.cosmic.nvidia-fixes";

        firefox-support.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "environment.cosmic.firefox-support";
        };

        optimize = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "environment.cosmic.optimize";
        };
    };

    config = lib.mkIf config.modules.environment.cosmic.enable (
        lib.mkMerge [
            {
                services.desktopManager.cosmic.enable = true;
            }

            # Auto-enable NVIDIA fixes if NVIDIA graphics module is enabled
            (lib.mkIf config.modules.common.hardware.graphics.nvidia.enable {
                modules.environment.cosmic.nvidia-fixes.enable = lib.mkDefault true;
            })

            (lib.mkIf config.modules.environment.cosmic.make-default {
                services.displayManager.defaultSession = "cosmic";
            })

            (lib.mkIf config.modules.environment.cosmic.greeter.enable {
                services.displayManager.cosmic-greeter.enable = true;
            })

            # Apply fullscreen flickering fixes
            (lib.mkIf config.modules.environment.cosmic.nvidia-fixes.enable {
                environment.sessionVariables = {
                    COSMIC_DISABLE_DIRECT_SCANOUT = "1";
                    COSMIC_DISABLE_OVERLAY_SCANOUT = "1";
                };
            })

            (lib.mkIf config.modules.environment.cosmic.firefox-support.enable {
                modules.programs.firefox.disable-libadwaita-theming = true;
            })

            (lib.mkIf config.modules.environment.cosmic.optimize {
                services.system76-scheduler.enable = lib.mkDefault true;
            })
        ]
    );
}
