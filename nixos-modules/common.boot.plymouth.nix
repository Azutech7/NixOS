{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.common.boot.plymouth.enable = lib.mkEnableOption "common.boot.plymouth";

    config = lib.mkIf config.modules.common.boot.plymouth.enable {

        boot = {
            plymouth = {
                enable = true;
                theme = "rings";
                #themePackages = with pkgs; [
                #    adi1090x-plymouth 
                #];
                #theme = "square_hud";
                themePackages = with pkgs; [
                    (adi1090x-plymouth-themes.override {
                        selected_themes = [ "rings" ];
                    })
                ];
            };

            # Enable "Silent boot"
            consoleLogLevel = 3;
            kernelParams = [
            "q.systemd.show_status=auto"
            ];

            # Hide the OS choice for bootloaders.
            loader.timeout = 0;
        };
    };
}
