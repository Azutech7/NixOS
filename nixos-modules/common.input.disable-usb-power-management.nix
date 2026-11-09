{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.common.input.disable-usb-power-management.enable = lib.mkEnableOption "common.input.disable-usb-power-management";

    config = lib.mkIf config.modules.common.input.disable-usb-power-management.enable {
        
        boot.kernelParams = [ 
            # Disables runtime power management for USB audio devices completely
            "usbcore.autosuspend=-1" 
        ];

    };
}
