{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.services.caddy.enable = lib.mkEnableOption "services.caddy";

    config = lib.mkIf config.modules.services.caddy.enable {

        services.caddy.enable = true;

    };
}


