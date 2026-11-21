{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.programs.flatpak.sober.enable = lib.mkEnableOption "programs.flatpak.sober";

    config = lib.mkIf config.modules.programs.flatpak.sober.enable {

        services.flatpak = {
            packages = [
                "org.vinegarhq.Sober"
            ];

            overrides.settings = {
                "org.vinegarhq.Sober".Context.sockets = [
                    "!wayland"
                    "x11"
                ];
            };
        };

    };
}
