{ inputs, pkgs, lib, host, config, ... }: {
    
    imports = [
        ./file-systems.nix
    ];

    modules = {
        common = {
            boot.enable = true;
            extra-experimental-features.enable = true;
            hardware.automatic-compatability.enable = true;
            hardware.graphics.intel-mesa.enable = true;
            home-manager.backup.enable = true;
            network.avahi.enable = true;
            network.network-manager.enable = true;
            nixpkgs.allow-unfree.enable = true;
            network.openssh.enable = true;
            security.gnupg.enable = true;
            security.network.firewall.enable = true;
            security.pam.enable = true;
            storage.space-optimizations.enable = true;

            security.network.dnscrypt-proxy.enable = true;
            security.network.unbound.enable = true;
            network.anti-panic.enable = true;
            security.network.tailscale.enable = true;
            security.network.adguard-home.enable = true;
        };

        services.aiostreams.enable = true;
        services.caddy.enable = true;
        #services.trakt.enable = true; #DOES NOT WORK CURRENTLY
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
    ];

    users.users.server-manager = {
        isNormalUser = true;
        group = "server-manager";
        extraGroups = [ "wheel" "networkmanager" ];
    };

    users.groups.server-manager = {};


    system.stateVersion = "26.05";

}