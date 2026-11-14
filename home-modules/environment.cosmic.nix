{ inputs, config, pkgs, lib, ... }: {

    options.modules.environment.cosmic = {
        enable = lib.mkEnableOption "environment.cosmic";

        theme-support.enable = lib.mkEnableOption "environment.cosmic.theme-support";
    };

    config = lib.mkIf config.modules.environment.cosmic.enable (
        lib.mkMerge [
            {
                services.desktopManager.cosmic.enable = true;
            }

            # Auto-enable NVIDIA fixes if NVIDIA graphics module is enabled
            (lib.mkIf config.modules.theme.enable {
                modules.environment.cosmic.theme-support.enable = lib.mkDefault true;
            })

            (lib.mkIf config.modules.environment.cosmic.theme-support.enable {
                xdg.configFile = {
                    "cosmic/com.system76.CosmicTk/v1/interface_font".text = ''
                        (
                            family: "${config.modules.theme.font.name}",
                            weight: Normal, 
                            stretch: Normal,
                            style: Normal,
                        )
                    '';
                    "cosmic/com.system76.CosmicTk/v1/monospace_font".text = ''
                        (
                            family: "${config.modules.theme.font.name}",
                            weight: Normal, 
                            stretch: Normal,
                            style: Normal,
                        )
                    '';
                };
            })
        ]
    );
}
