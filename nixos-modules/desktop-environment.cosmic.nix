{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.desktop-environment.cosmic = {
        enable = lib.mkEnableOption "desktop-environment.cosmic";

        default = lib.mkEnableOption "desktop-environment.cosmic.default";

        optimize = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "desktop-environment.cosmic.optimize";
        };

        greeter = lib.mkOption {
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

            (lib.mkIf config.modules.desktop-environment.cosmic.default {
                services.displayManager.defaultSession = "cosmic";
            })

            (lib.mkIf config.modules.desktop-environment.cosmic.optimize {
                services.system76-scheduler.enable = lib.mkDefault true;
            })

            (lib.mkIf config.modules.desktop-environment.cosmic.greeter {
                services.displayManager.cosmic-greeter.enable = true;
            })
        ]
    );
}
