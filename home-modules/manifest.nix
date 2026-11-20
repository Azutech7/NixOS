{ inputs, config, pkgs, lib, ... }: {
    imports = [
        # Flake
        inputs.noctalia.homeModules.default
        inputs.umbriel.homeModules.default
        inputs.nvf.homeModules.default
        inputs.nix-flatpak.homeManagerModules.nix-flatpak

        # Files
        ./bash.nix
        ./btop.nix
        ./cava.nix
        ./environment.cosmic.nix
        ./environment.noctalia.nix
        ./environment.umbriel.nix
        ./fastfetch.nix
        ./firefox.nix
        ./fuzzel.nix
        ./hyprland.hypridle.nix
        ./hyprland.hyprlock.nix
        ./hyprland.hyprshot.nix
        ./hyprland.nix
        ./kitty.nix
        ./mako.nix
        ./micro.nix
        ./programs.flatpak.nix
        ./programs.flatpak.sober.nix
        ./programs.libreoffice.nix
        ./programs.nvf.nix
        ./spotify-player.nix
        ./theme.nix
        ./vesktop.nix
        ./vscodium.nix
        ./waybar.nix
        ./wayland-clipboard.nix
    ];
}