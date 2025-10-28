{...}: {
  programs.nixvim.plugins = {
    cmp = {
      autoEnableSources = false;
      enable = true;
      settings = {
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        formatting = {
          fields = ["kind" "abbr" "menu"];
          format = ''
            function(entry, vim_item)
            	local kind_icons = {
            		Text = "󰉿",
            		Method = "󰆧",
            		Function = "󰊕",
            		Constructor = "",
            		Field = " ",
            		Variable = "󰀫",
            		Class = "󰠱",
            		Interface = "",
            		Module = "",
            		Property = "󰜢",
            		Unit = "󰑭",
            		Value = "󰎠",
            		Enum = "",
            		Keyword = "󰌋",
            		Snippet = "",
            		Color = "󰏘",
            		File = "󰈙",
            		Reference = "",
            		Folder = "󰉋",
            		EnumMember = "",
            		Constant = "󰏿",
            		Struct = "",
            		Event = "",
            		Operator = "󰆕",
            		TypeParameter = " ",
            		Misc = " ",
            	}
            	vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            	vim_item.abbr = vim_item.abbr .. "  " .. (vim_item.menu and vim_item.menu or "")
            	if vim.fn.strchars(vim_item.abbr) > 50 then
            		vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, 50) .. "..."
            	end
            	vim_item.menu = ({
            		nvim_lsp = "[LSP]",
            		luasnip = "[Snippet]",
            		buffer = "[Buffer]",
            		path = "[Path]"
            	})[entry.source.name]
            	return vim_item
            end
          '';
        };
        mapping.__raw = ''          cmp.mapping.preset.insert({
          				["<C-d>"] = cmp.mapping.scroll_docs(-4),
          				["<C-f>"] = cmp.mapping.scroll_docs(4),
          				["<C-Space>"] = cmp.mapping.complete(),
          				["<CR>"] = cmp.mapping.confirm({
          					behavior = cmp.ConfirmBehavior.Replace,
          					select = true,
          				}),
          				["<S-TAB>"] = cmp.mapping.select_prev_item(),
          				["<TAB>"] = cmp.mapping.select_next_item(),
          			})'';
        window = {
          completion.__raw = "cmp.config.window.bordered()";
          documentation.__raw = "cmp.config.window.bordered()";
        };
        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "path";}
          {name = "buffer";}
          {name = "crates";}
        ];
      };
    };
    cmp_luasnip.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-nvim-lsp.enable = true;
    luasnip.enable = true;
  };
}
