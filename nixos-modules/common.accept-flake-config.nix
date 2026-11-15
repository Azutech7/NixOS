{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.common.accept-flake-config.enable = lib.mkEnableOption "common.accept-flake-config";

    config = lib.mkIf config.modules.common.accept-flake-config.enable {

        nix.settings.accept-flake-config = true;

    };
}
