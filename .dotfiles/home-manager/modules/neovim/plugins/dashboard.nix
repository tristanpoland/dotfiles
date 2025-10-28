{...}: {
  programs.nixvim.plugins.dashboard = {
    enable = true;
    lazyLoad.enable = false;
    autoLoad = true;
    settings = {
      theme = "doom";
      change_to_vcs_root = true;
      config = {
        footer = [
          "Configured in  Nix with   "
        ];
        header = [
          "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
          "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
          "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
          "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
          "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];
        center = [
          {
            desc = "  Caz's Nixvim Configuration";
            desc_hl = "group";
          }
          {
            action = "lua print(2)";
            desc = "Find File           ";
            desc_hl = "String";
            icon = " ";
            icon_hl = "Title";
            key = "f";
            key_format = " %s";
            key_hl = "Number";
            keymap = "SPC s";
          }
        ];
        vertical_center = true;
      };
    };
  };

  programs.nixvim.plugins.indent-blankline.luaConfig.post = ''
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dashboard",
      callback = function()
        require("ibl").setup_buffer(0, { enabled = false })
      end,
    })
  '';
}
