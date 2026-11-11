{ inputs, config, lib, pkgs, ... }:

let
  open-vsx-pkgs = inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx;
in
{
    options.modules.vscodium.enable = lib.mkEnableOption "vscodium";

    config = lib.mkIf config.modules.vscodium.enable {

        programs.vscodium = {
            enable = true;

            profiles.default.extensions = (with pkgs.vscode-extensions; [
                jnoortheen.nix-ide
                zhuangtongfa.material-theme
                redhat.java
                redhat.vscode-yaml
                pkief.material-icon-theme
                esbenp.prettier-vscode
                ms-vscode.cmake-tools
                shd101wyy.markdown-preview-enhanced
            ]) ++ (with open-vsx-pkgs; [
                jeanp413.open-remote-ssh
            ]);
        };

    };
}
