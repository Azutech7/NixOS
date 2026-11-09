{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.programs.flatpak.enable = lib.mkEnableOption "programs.flatpak";

    config = lib.mkIf config.modules.programs.flatpak.enable {

        services.flatpak.enable = true;

    };
}
