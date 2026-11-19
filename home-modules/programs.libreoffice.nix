{ inputs, config, lib, pkgs, ... }: {

    options.modules.programs.libreoffice = {
        enable = lib.mkEnableOption "programs.libreoffice";
    };
    
    config = lib.mkIf config.modules.programs.libreoffice.enable {
        
        programs.libreoffice = {
            enable = true;
        };

    };
}