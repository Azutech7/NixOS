{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.common.laptop.battery-optimizations.enable = lib.mkEnableOption "common.laptop.battery-optimizations";

    config = lib.mkIf config.modules.common.laptop.battery-optimizations.enable {

        powerManagement.enable = true;
        services.thermald.enable = true;
        #services.tlp.enable = true;

    };
}
