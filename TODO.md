# TODO LIST:

- [ ] systemd hardening (ProtectSystem, ProtectHome, PrivateTmp, NoNewPrivileges)
- [ ] sops-nix (secrets management)
- [ ] java integration (cli runner w/ System.in tracking)
- [ ] disko integration (alongside NixOS fileSystems)
- [ ] satty (screenshot editing)
- [ ] grlim+slurp (instead of hyprshot)
- [ ] Automatic updates from GitHub
- [ ] Refactor away from the common system, it has gotten too far
- [ ] ThinkFan ACPI module
- [ ] Built in module options wrapper
- [ ] Update Hyprland + ly to prevent default-conflicts within other DEs
- [ ] Transition to podman instead of docker AFTER mcserver closes
- [ ] Link modules to flakes
- [ ] Move some more host-level stuff like the system state version into the flake
- [x] Make a system module for "nix.settings.accept-flake-config = true;"
- [ ] Add automatic theme management for 3rd party programs with noctalia
- [ ] Have atlas host feishin web client
- [ ] Have atlas host a hydra instance for this repo

# DOING SOON:

- [x] VERY basic nvf
- [x] Declartivive flatpak management
    - [x] Sober integration
    - [ ] AIOStreams integration <- find alt.
- [x] Re-enable libadwaita stuff (mostly for Firefox)
- [x] Libre Office user-level module
