{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.common.hardware.disable-intel-amt.enable = lib.mkEnableOption "common.hardware.disable-intel-amt";

    config = lib.mkIf config.modules.common.hardware.disable-intel-amt.enable {

        boot.kernelParams = [ "intel_idle.max_cstate=1" ];
        boot.blacklistedKernelModules = [ "mei" "mei_me" "mei_hdcp" ];

    };
}
