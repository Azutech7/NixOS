{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.desktop-environment.hyprland.enable = lib.mkEnableOption "desktop-environment.hyprland";

    config = lib.mkIf config.modules.desktop-environment.hyprland.enable {
	
		programs.hyprland = {
			enable = true;
			xwayland.enable = true;
		};

		services.xserver.enable = true;
		services.xserver.xkb.layout = "us";
		services.displayManager.defaultSession = lib.mkDefault "hyprland";

	};
}
