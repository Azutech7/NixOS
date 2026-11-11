{ inputs, config, lib, pkgs, ... }: {

    options.modules.firefox.enable = lib.mkEnableOption "firefox";

    config = lib.mkIf config.modules.firefox.enable {

        programs.firefox = {
            enable = true;

            policies = {
                Preferences = {
                    "network.dns.echconfig.enabled" = true;
                    "network.dns.use_https_rr_as_alpn" = true;
                };
            };

            configPath = "${config.xdg.configHome}/mozilla/firefox";
        };

    };
}
