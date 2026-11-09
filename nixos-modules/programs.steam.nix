{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.programs.steam.enable = lib.mkEnableOption "programs.steam";

    config = lib.mkIf config.modules.programs.steam.enable {

		programs.steam = {
			enable = true;

			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;

			gamescopeSession.enable = true;

			extraCompatPackages = with pkgs; [
				proton-ge-bin
			];
		};

    };
}
