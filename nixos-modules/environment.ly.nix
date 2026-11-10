{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.environment.ly.enable = lib.mkEnableOption "environment.ly";

    config = lib.mkIf config.modules.environment.ly.enable {

        services.displayManager.ly.enable = true;

    };
}
