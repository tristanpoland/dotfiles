{...}: {
  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
      file-browser.enable = true;
    };
    settings = {
      theme = "dropdown";
      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
        entry_prefix = "  ";
        initial_mode = "insert";
        selection_strategy = "reset";
        layout_config = {};
        mappings.i = {
          "<C-u>" = false;
          "<C-d>" = false;
        };
        file_ignore_patters = {};
        path_display = "smart";
        winblend = 0;
        border = {};
        borderchars = null;
        color_devicons = true;
        set_env = {COLORTERM = "truecolor";};
      };
      pickers = {
        planets = {
          show_pluto = true;
          show_moon = true;
        };
        git_files = {
          hidden = true;
          show_untracked = true;
        };
        colorscheme = {
          enable_preview = true;
        };
        find_files = {
          hidden = true;
        };
      };
    };
  };
}
