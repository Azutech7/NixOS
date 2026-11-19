{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.programs.flatpak.enable = lib.mkEnableOption "programs.flatpak";

    config = lib.mkIf config.modules.programs.flatpak.enable {

        services.flatpak = {
            enable = true;

            remotes = [
                {
                    name = "flathub";
                    location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; 
                }
                {
                    name = "flathub-beta";
                    location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
                }
            ];

            update.auto = {
                enable = true;
                onCalendar = "weekly";
            };
        };

    };
}
