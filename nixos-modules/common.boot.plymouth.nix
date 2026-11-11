{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.common.boot.plymouth.enable = lib.mkEnableOption "common.boot.plymouth";

    config = lib.mkIf config.modules.common.boot.plymouth.enable {

        boot.plymouth = {
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

    };
}
