{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.environment = {
        enable = lib.mkEnableOption "environment";

        xserver.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "environment.xserver";
        };

        compatability-links.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "environment.compatability-links";
        };

        display-manager-assertions.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "environment.display-manager-assertions";
        };
    };

    config = lib.mkIf config.modules.environment.enable (
        lib.mkMerge [
            (lib.mkIf config.modules.environment.xserver.enable {
                services.xserver.enable = true;
			    services.xserver.xkb.layout = "us";
            })

            (lib.mkIf config.modules.environment.compatability-links.enable {
                environment.pathsToLink = [
                    "/share/applications"
                    "/share/xdg-desktop-portal"
                ];
            })

            (lib.mkIf config.modules.environment.display-manager-assertions.enable (let
                mutually-exclusive-display-managers = [
                    config.modules.environment.cosmic.greeter.enable
                    config.modules.environment.ly.enable
                ];
                active-display-manager-count = lib.count (x: x) mutually-exclusive-display-managers;
            in {
            assertions = [
                {
                    assertion = active-display-manager-count <= 1;
                    message = ''
                        Mutually exclusive display managers detected! 
                        You have enabled multiple display managers simultaneously under config.modules.environment, 
                        but you can only use one at a time.
                    '';
                }
            ];}))
        ]

    );
}
