{config, ...}: {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    opts = {
      colorcolumn = "79";
      hlsearch = false;
      number = true;
      relativenumber = true;

      scrolloff = 25;

      tabstop = 4;
      shiftwidth = 0;
      autoindent = true;

      ignorecase = true;
      smartcase = true;
      incsearch = true;

      termguicolors = true;
      background = "dark";
      mouse = "a";

      breakindent = true;
      undofile = true;
      undodir = "${config.home.homeDirectory}/.vim/undodir";

      updatetime = 250;
      signcolumn = "yes";
      completeopt = "menuone,noselect";
    };

    autoGroups.YankHighlight.clear = true;
    autoCmd = [
      {
        event = "TextYankPost";
        callback = {__raw = "function() vim.highlight.on_yank() end";};
        group = "YankHighlight";
        pattern = "*";
      }
      {
        event = ["BufRead" "BufNewFile"];
        pattern = "*";
        command = "set tabstop=4";
      }
      {
        event = ["BufRead" "BufNewFile"];
        pattern = "*.qml";
        command = "set filetype=qml";
      }
    ];
  };
}
