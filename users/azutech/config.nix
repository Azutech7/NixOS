{ inputs, pkgs, lib, config, ... }: {

    imports = [
        ./theme-profile.selenized.nix
    ];

    modules = {
        # Core
        bash.enable = true;
        btop.enable = true;
        cava.enable = true;
        firefox.enable = true;
        fastfetch.enable = true;
        kitty.enable = true;
        micro.enable = true;
        theme.enable = true;
        wayland-clipboard.enable = true;

        # Extra
        vscodium.enable = true;
    };

    home.packages = with pkgs; [
        discord
        zoom-us
        prismlauncher
        feishin
        heroic
    ];

    programs.git.enable = true;
	programs.git.settings = {
		user.name = "Azutech7";
		user.email = "masonheuberger@gmail.com";
	};

}
