{ inputs, pkgs, lib, host, config, ... }: {
    
    imports = [
        ./file-systems.nix
    ];

    modules = {
        common = {
            audio.pipewire.enable = true;

            boot.enable = true;
            boot.plymouth.enable = true;

            extra-experimental-features.enable = true;

            hardware.automatic-compatability.enable = true;
            hardware.graphics.intel-mesa.enable = true;
            hardware.graphics.enable = true;

            home-manager.backup.enable = true;

            input.disable-usb-power-management.enable = true;
            input.touchpad.enable = true;

            laptop.battery-optimizations.enable = true;

            network.avahi.enable = true;
            network.bluetooth.enable = true;
            network.captive-browser.enable = true;
            network.network-manager.enable = true;
            network.openssh.enable = true;
            network.printing.enable = true;
            
            nixpkgs.allow-unfree.enable = true;

            security.auditd.enable = true;
            security.gnupg.enable = true;
            security.network.fail2ban.enable = true;
            security.network.firewall.enable = true;
            security.network.tailscale.enable = true;
            security.pam.enable = true;

            storage.btrfs.auto-scrub.enable = true;
            storage.space-optimizations.enable = true;
        };

        environment.cosmic = {
            enable = true;
            make-default = true;
            greeter.enable = true;
        };

        programs.firefox.enable = true;
        programs.flatpak.enable = true;
        programs.java.enable = true;
        programs.steam.enable = true;
    };

    environment.systemPackages = with pkgs; [
        micro
        wget
        git
        yazi
        btop
        unzip
        p7zip
        fzf
        libgcc
        tree
        parted
        unrar
    ];

    users.users.azutech = {
        isNormalUser = true;
        group = "azutech";
        extraGroups = [ "wheel" "networkmanager" ];
    };

    users.groups.azutech = {};

    time.timeZone = "America/Los_Angeles";

    system.stateVersion = "26.05";

}