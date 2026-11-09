{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.programs.java.enable = lib.mkEnableOption "programs.java";

    config = lib.mkIf config.modules.programs.java.enable {

        programs.java.enable = true;
        
    };
}
