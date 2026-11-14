{ inputs, config, pkgs, lib, host, ... }: {

    imports = [
        inputs.noctalia.nixosModules.default
    ];

    options.modules.environment.noctalia = {
        enable = lib.mkEnableOption "environment.noctalia";

        include-recommended = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "environment.noctalia.include-recommended";
        };
    };

    config = lib.mkIf config.modules.environment.noctalia.enable (
        lib.mkMerge [
            {
                programs.noctalia.enable = true;
            }

            (lib.mkIf config.modules.environment.noctalia.include-recommended {
                programs.noctalia.recommendedServices.enable = true;
            })
        ]
    );
}
