{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.desktop-environment.ly.enable = lib.mkEnableOption "desktop-environment.ly";

    config = lib.mkIf config.modules.desktop-environment.ly.enable {

        services.displayManager.ly.enable = true;

    };
}
