{ inputs, pkgs, lib, host, config, ... }: {

	options.modules.common.security.auditd.enable = lib.mkEnableOption "common.security.auditd";

	config = lib.mkIf config.modules.common.security.auditd.enable {

        security.audit.enable = true;
        security.auditd.enable = true;

    };
}
