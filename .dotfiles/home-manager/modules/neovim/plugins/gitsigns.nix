{...}: {
  programs.nixvim.plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add.text = "▎";
        change.text = "▎";
        delete.text = "";
        topdelete.text = "";
        changedelete.text = "▎";
      };

      signs_staged_enable = true;
      signcolumn = true;
      numhl = false;
      linehl = false;
      word_diff = false;
      watch_gitdir = {
        interval = 1000;
        follow_files = true;
      };
      attach_to_untracked = true;
      current_line_blame = false;
      current_line_blame_opts = {
        virt_text = true;
        virt_text_pos = "eol";
        delay = 100;
        ignore_whitespace = true;
      };

      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> — <summary>";
      sign_priority = 6;
      status_formatter = null;
      update_debounce = 200;
      max_file_length = 40000;
      preview_config = {
        border = "rounded";
        style = "minimal";
        relative = "cursor";
        row = 0;
        col = 1;
      };
    };
  };
}
