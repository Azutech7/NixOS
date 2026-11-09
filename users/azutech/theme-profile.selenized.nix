{ inputs, pkgs, lib, config, ... }: 

{
	config.modules.theme = {
		color = {
			#### Monochrome ####
			background = "181818";
			br_background = "252525";
			foreground = "b9b9b9";
			cursor = "dedede";
			selection = "3b3b3b";
			comment = "777777";

			#### Favorites ####
			primary = "a580e2";
			#secondary = __;
			#tertiary = __;
			#quaternary = __;

			#### Standard ####
			red = "ed4a46";
			orange = "e67f43";
			yellow = "dbb32d";
			green = "70b433";
			cyan = "3fc5b7";
			blue = "368aeb";
			magenta = "eb6eb7";
			violet = "a580e2";

			#### Bright ####
			br_red = "ff5e56";
			br_orange = "fa9153";
			br_yellow = "efc541";
			br_green = "83c746";
			br_cyan = "56d8c9";
			br_blue = "4f9cfe";
			br_magenta = "ff81ca";
			br_violet = "b891f5";
		};

		image = {
			wallpaper = ./wallpaper.png;
			fetch-icon = ./fetch-icon.png;
		};

		font = {
			package = pkgs.maple-mono.NF-unhinted;
			name = "Maple Mono";
			size.default = 12;
		};

		cursor = {
			package = pkgs.phinger-cursors;
			name = "phinger-cursors-dark";
			size = 24;
		};
	};
}
