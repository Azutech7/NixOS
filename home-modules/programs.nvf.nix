{ inputs, config, lib, pkgs, ... }: {

  options.modules.programs.nvf = {
    enable = lib.mkEnableOption "programs.nvf";
  };

  config = lib.mkIf config.modules.programs.nvf.enable {

programs.nvf = {
    enable = true;
    enableManpages = true;

    settings.vim = {
      # Aliases
      viAlias = true;
      vimAlias = true;

      # Clipboard (syncs with wl-clipboard on Wayland)
      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };

      # Editor Options
      options = {
        tabstop = 4;
        shiftwidth = 4;
        softtabstop = 4;
        expandtab = true;

        ignorecase = true;
        smartcase = true;
        signcolumn = "yes";
        scrolloff = 8;

        number = true;
        relativenumber = true;
      };

      # Theme
      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };

      # UI & Layout
      statusline.lualine.enable = true;
      tabline.nvimBufferline.enable = true;
      filetree.neo-tree.enable = true;
      terminal.toggleterm.enable = true;

      # Navigation & Editing Helpers
      telescope.enable = true;
      treesitter.enable = true;
      autopairs.nvim-autopairs.enable = true;
      comments.comment-nvim.enable = true;
      binds.whichKey.enable = true;

      # Autocompletion
      autocomplete.blink-cmp.enable = true;

      # LSP, Formatting & Troubleshooting
      lsp = {
        enable = true;
        formatOnSave = true;
        trouble.enable = true;
      };

      # Languages (automatically configures LSP, Treesitter, and formatters)
      languages = {
        enableTreesitter = true;
        enableFormat = true;

        nix.enable = true;
        java.enable = true;
        lua.enable = true;
        python.enable = true;
        rust.enable = true;
      };

      # Git Integration
      git = {
        enable = true;
        gitsigns.enable = true;
      };
      utility.diffview-nvim.enable = true;
    };
  };

  };
}
