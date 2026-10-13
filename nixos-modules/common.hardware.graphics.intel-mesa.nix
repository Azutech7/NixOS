{ inputs, pkgs, lib, host, config, ... }: {

    options.modules.common.hardware.graphics.intel-mesa.enable = lib.mkEnableOption "common.hardware.intel-mesa";

    config = lib.mkIf config.modules.common.hardware.graphics.intel-mesa.enable {

        hardware.graphics.extraPackages = with pkgs; [
            intel-media-driver
            intel-compute-runtime
            ocl-icd
        ];

    };
}
