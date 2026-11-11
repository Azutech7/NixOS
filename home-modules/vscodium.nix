{ inputs, config, lib, pkgs, ... }: {

    options.modules.vscodium.enable = lib.mkEnableOption "vscodium";

    config = lib.mkIf config.modules.vscodium.enable {

        programs.vscodium = {
            enable = true;

            profiles.default.extensions = with pkgs.vscode-extensions; [
                jnoortheen.nix-ide
                jeanp413.open-remote-ssh
                zhuangtongfa.material-theme
                redhat.java
                redhat.vscode-yaml
                PKief.material-icon-theme
                esbenp.prettier-vscode
                ms-vscode.cmake-tools
                shd101wyy.markdown-preview-enhanced
                ms-vscode.cpptools
            ];
        };

    };
}
