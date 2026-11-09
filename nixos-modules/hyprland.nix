{ inputs, config, pkgs, lib, host, ... }: {

    options.modules.hyprland.enable = lib.mkEnableOption "hyprland";

    config = lib.mkIf config.modules.hyprland.enable {
	
		programs.hyprland = {
			enable = true;
			xwayland.enable = true;
		};

		services.xserver.enable = true;
		services.xserver.xkb.layout = "us";
		services.displayManager.defaultSession = lib.mkDefault "hyprland";

	};
}
