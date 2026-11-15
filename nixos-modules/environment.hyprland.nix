{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.environment.hyprland.enable = lib.mkEnableOption "environment.hyprland";

    config = lib.mkIf config.modules.environment.hyprland.enable { # <- DOES NOT INCLUDE ENV CURRENTLY SO BROKEN & OUTDATED
	
			programs.hyprland = {
				enable = true;
				xwayland.enable = true;
			};
			
			services.displayManager.defaultSession = lib.mkDefault "hyprland";

	};
}
