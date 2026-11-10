{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.common.audio.pipewire = {
        enable = lib.mkEnableOption "common.audio.pipewire";

        anti-stutter.enable = lib.mkEnableOption "common.audio.pipewire.anti-stutter";
    };

    config = lib.mkIf config.modules.common.audio.pipewire.enable (

        lib.mkMerge [

            {
                services.pipewire = {
                    enable = true;
                    alsa.enable = true;
                    alsa.support32Bit = true;
                    pulse.enable = true;
                    jack.enable = true;
                };

                environment.systemPackages = with pkgs; [
                    wiremix
                ];
            }

            (lib.mkIf config.modules.common.audio.pipewire.anti-stutter.enable {
                services.pipewire.extraConfig.pipewire."92-low-latency" = {
                    "context.properties" = {
                        "default.clock.rate" = 48000;
                        "default.clock.quantum" = 1024;       # Prevents micro-stutters
                        "default.clock.min-quantum" = 512;    # Sets the safety floor
                        "default.clock.max-quantum" = 2048;
                    };
                };

                security.rtkit.enable = true;
            })

        ]

    );
}
