{...}: {
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        background = {
          light = "latte";
          dark = "mocha";
        };
        transparent_background = true;
        show_end_of_buffer = false;
        term_colors = false;
        dim_inactive.enabled = false;
        no_italic = false;
        no_bold = false;
        styles = {
          comments = ["italic"];
          conditionals = ["italic"];
          loops = null;
          functions = null;
          keywords = null;
          strings = null;
          variables = null;
          numbers = null;
          booleans = null;
          properties = null;
          types = null;
          operators = null;
        };
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          telescope = true;
          notify = false;
          mini = false;
        };
      };
    };
  };
}
