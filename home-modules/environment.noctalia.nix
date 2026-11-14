{ inputs, config, lib, pkgs, ... }: {

    imports = [
        inputs.noctalia.homeModules.default
    ];

    options.modules.environment.noctalia.enable = lib.mkEnableOption "environment.noctalia";

    config = lib.mkIf config.modules.environment.noctalia.enable {

        programs.noctalia = {
            enable = true;

            settings = {
                #go here
            };
        };

    };
}
