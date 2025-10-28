{...}: {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    keymaps = [
      {
        mode = ["n" "v"];
        key = "<SPACE>";
        action = "<NOP>";
        options.silent = true;
      }

      {
        mode = "n";
        key = "<LEADER>,";
        action = "A,<ESC>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<LEADER>j";
        action = "<CMD>NvimTreeToggle<CR>";
      }
      {
        mode = "n";
        key = "<LEADER>gc";
        action.__raw = "require('telescope.builtin').git_commits";
        options = {
          silent = true;
          desc = "[G]it [C]ommits";
        };
      }
      {
        mode = "n";
        key = "<LEADER>gs";
        action.__raw = "require('telescope.builtin').git_status";
        options = {
          silent = true;
          desc = "[G]it [S]tatus";
        };
      }
      {
        mode = "n";
        key = "<LEADER>sf";
        action.__raw = "require('telescope.builtin').find_files";
        options = {
          silent = true;
          desc = "[S]earch [F]iles";
        };
      }
      {
        mode = "n";
        key = "<LEADER><SPACE>";
        action = {__raw = "require\"telescope.builtin\".buffers";};
        options = {
          silent = true;
          desc = "[ ] Find existing buffers";
        };
      }
    ];
  };
}
