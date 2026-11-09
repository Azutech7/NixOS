{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.desktop-environment.cosmic = {
        enable = lib.mkEnableOption "desktop-environment.cosmic";

        make-default = lib.mkEnableOption "desktop-environment.cosmic.make-default";

        firefox-support.enable = lib.mkEnableOption "ddesktop.environment.cosmic.firefox-support";

        optimize = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "desktop-environment.cosmic.optimize";
        };

        greeter.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "desktop-environment.cosmic.greeter";
        };
    };

    config = lib.mkIf config.modules.desktop-environment.cosmic.enable (
        lib.mkMerge [
            {
                services.desktopManager.cosmic.enable = true;
            }

            (lib.mkIf config.modules.desktop-environment.cosmic.make-default {
                services.displayManager.defaultSession = "cosmic";
            })

            (lib.mkIf config.modules.desktop-environment.cosmic.firefox-support.enable {
                config.modules.programs.firefox.disable-libadwaita-theming = true;
            })

            (lib.mkIf config.modules.desktop-environment.cosmic.optimize {
                services.system76-scheduler.enable = lib.mkDefault true;
            })

            (lib.mkIf config.modules.desktop-environment.cosmic.greeter.enable {
                services.displayManager.cosmic-greeter.enable = true;
            })
        ]
    );
}
