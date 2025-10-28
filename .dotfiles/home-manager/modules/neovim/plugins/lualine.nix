{...}: {
  programs.nixvim.plugins.lualine = {
    enable = true;
    settings = {
      options = {
        icons_enabled = true;
        component_seperators = {
          left = "|";
          right = "|";
        };
        section_seperators = {
          left = "";
          right = "";
        };
        disabled_filetypes.statusline = ["NvimTree" "alpha"];
        disabled_filetypes.winbar = ["NvimTree" "alpha"];
        theme = null;
      };
    };
  };
}
