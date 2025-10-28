{config, ...}: {
  programs.nixvim.plugins.treesitter = {
    enable = true;
    nixvimInjections = true;
    settings = {
      indent.enable = true;
      incremental_selection = {
        enable = true;
        #        keymaps = {
        #          init_selection = "<c-space>";
        #          node_incremental = "<c-space>";
        #          scope_incremental = "<c-s";
        #          node_decremental = "<c-backspace>";
        #        };
      };
      highlight.enable = true;
    };
  };
}
