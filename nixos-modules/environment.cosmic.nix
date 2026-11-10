{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.environment.cosmic = {
        enable = lib.mkEnableOption "environment.cosmic";

        make-default = lib.mkEnableOption "environment.cosmic.make-default";

        greeter.enable = lib.mkEnableOption "environment.cosmic.greeter";

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

            (lib.mkIf config.modules.environment.cosmic.make-default {
                services.displayManager.defaultSession = "cosmic";
            })

            (lib.mkIf config.modules.environment.cosmic.greeter.enable {
                services.displayManager.cosmic-greeter.enable = true;
            })

            (lib.mkIf config.modules.environment.cosmic.firefox-support.enable {
                config.modules.programs.firefox.disable-libadwaita-theming = true;
            })

            (lib.mkIf config.modules.environment.cosmic.optimize {
                services.system76-scheduler.enable = lib.mkDefault true;
            })
        ]
    );
}
