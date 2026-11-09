{ inputs, pkgs, lib, config, ... }: {

    imports = [
        ./theme-profile.selenized.nix
    ];

    modules = {
        bash.enable = true;
        btop.enable = true;
        cava.enable = true;
        fastfetch.enable = true;
        kitty.enable = true;
        micro.enable = true;
        theme.enable = true;
        wayland-clipboard.enable = true;
    };

}