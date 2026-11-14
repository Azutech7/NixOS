{ inputs, config, pkgs, lib, host, ... }: {

    imports = [
        inputs.umbriel.nixosModules.default
    ];

    options.modules.environment.umbriel = {
        enable = lib.mkEnableOption "environment.umbriel";

        make-default = lib.mkEnableOption "environment.umbriel.make-default";
    };

    config = lib.mkIf config.modules.environment.umbriel.enable (
        lib.mkMerge [
            {
                programs.umbriel.enable = true;
            }

            (lib.mkIf config.modules.environment.umbriel.make-default {
                services.displayManager.defaultSession = "umbriel";
            })
        ]
    );
}
