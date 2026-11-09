{ inputs, pkgs, lib, host, config, ... }: {

	options.modules.common.extra-experimental-features = {
        enable = lib.mkEnableOption "common.extra-experimental-features";

        nix-command = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "common.extra-experimental-features.nix-command";
        };

        flakes = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "common.extra-experimental-features.flakes";
        };
    };

	config = lib.mkIf config.modules.common.extra-experimental-features.enable {
        nix.settings.experimental-features = lib.mkMerge [
            (lib.mkIf config.modules.common.extra-experimental-features.nix-command [ "nix-command" ])
            (lib.mkIf config.modules.common.extra-experimental-features.flakes [ "flakes" ])
        ];
    };
}
