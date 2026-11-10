{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.programs.firefox = {
        enable = lib.mkEnableOption "programs.firefox";

        disable-libadwaita-theming = lib.mkEnableOption "programs.firefox.disable-libadwaita-theming";
    }

    config = lib.mkIf config.modules.programs.firefox.enable (

        lib.mkMerge [
            {
                programs.java.enable = true;
            }

            (lib.mkIf config.modules.programs.firefox.disable-libadwaita-theming {
                programs.firefox.preferences = {
                    # disable libadwaita theming for Firefox
                    "widget.gtk.libadwaita-colors.enabled" = false;
                };
            })
        ]

    );
}
