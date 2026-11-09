{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.desktop-environment = {
        compatability-links.enable = lib.mkEnableOption "desktop-environment.compatability-links";
    };

    config = {
        lib.mkMerge [

            (lib.mkIf config.modules.desktop-environment.compatability-links.enable {
                environment.pathsToLink = [
                    "/share/applications"
                    "/share/xdg-desktop-portal"
                ];
            })

        ]
    };
}
