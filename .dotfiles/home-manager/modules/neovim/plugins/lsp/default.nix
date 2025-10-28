{pkgs, ...}: {
  imports = [
    ./cmp.nix
  ];
  programs.nixvim.plugins = {
    crates.enable = true; # Does not work
    dressing.enable = true;
  };
  programs.nixvim.extraConfigVim = ''
    augroup unrecognized_filetypes
      autocmd!
      autocmd BufRead,BufNewFile *.vert set filetype=glsl
      autocmd BufRead,BufNewFile *.tesc set filetype=glsl
      autocmd BufRead,BufNewFile *.tese set filetype=glsl
      autocmd BufRead,BufNewFile *.frag set filetype=glsl
      autocmd BufRead,BufNewFile *.geom set filetype=glsl
      autocmd BufRead,BufNewFile *.comp set filetype=glsl
      autocmd BufRead,BufNewFile *.qml set filetype=qml
      autocmd BufRead,BufNewFile *.slint set filetype=slint
      autocmd BufRead,BufNewFile *.typ set filetype=typst
    augroup END
  '';
  programs.nixvim.plugins.lsp = {
    enable = true;

    capabilities = ''
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      capabilities.textDocument.completion.completionItem.snippetSupport = true'';
    preConfig = ''
      local border = {
      	{ "╭", "FloatBorder" },
      	{ "─", "FloatBorder" },
      	{ "╮", "FloatBorder" },
      	{ "│", "FloatBorder" },
      	{ "╯", "FloatBorder" },
      	{ "─", "FloatBorder" },
      	{ "╰", "FloatBorder" },
      	{ "│", "FloatBorder" }
      }
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
    '';

    inlayHints = true;
    servers = {
      harper_ls.enable = true;
      clangd = {
        enable = true;
        settings.arguments = [
          "--clang-tidy"
          "--background-index"
          "--completion-style=detailed"
          "--cross-file-rename"
          "--header-insertion=iwyu"
          "--all-scopes-completion"
        ];
      };
      #          jdtls.enable = true;
      emmet_ls.enable = true;
      ts_ls.enable = true;
      cssls.enable = true;
      # glsl_analyzer.enable = true;
      glslls.enable = true;
      pyright.enable = true;
      nixd.enable = true;
      lua_ls = {
        enable = true;
        settings = {
          telemetry.enable = false;
          workspace.checkThirdParty = false;
        };
      };
      svelte = {
        enable = true;
        settings.enable_ts_plugin = true;
      };
      slint_lsp.enable = true;
      zls.enable = true;
      rust_analyzer = {
        enable = true;
        installRustc = false;
        installCargo = false;
        settings = {
          imports = {
            granularity.group = "crate";
            prefix = "self";
            preferNoStd = true;
          };
          check = {
            command = "clippy";
            allTargets = true;
          };
          completion = {
            fullFunctionSignatures.enable = false;
            autoimport.enable = true;
          };
          cargo = {
            allTargets = true;
            features = "all";
          };
          procMacro.enable = true;
        };
      };
    };
    keymaps = {
      silent = true;
      extra = [
        {
          mode = "n";
          key = "<leader>rn";
          action.__raw = "vim.lsp.buf.rename";
        }
        {
          mode = "n";
          key = "<leader>ca";
          action.__raw = "vim.lsp.buf.code_action";
        }
        {
          mode = "n";
          key = "<leader>di";
          action.__raw = "vim.diagnostic.open_float";
        }
        {
          mode = "n";
          key = "<leader>dv";
          action.__raw = "require('telescope.builtin').diagnostics";
        }

        {
          mode = "n";
          key = "gd";
          action.__raw = "vim.lsp.buf.definition";
        }
        {
          mode = "n";
          key = "gr";
          action.__raw = "require('telescope.builtin').lsp_references";
        }
        {
          mode = "n";
          key = "gI";
          action.__raw = "vim.lsp.buf.implementation";
        }
        {
          mode = "n";
          key = "<leader>D";
          action.__raw = "vim.lsp.buf.type_definition";
        }
        {
          mode = "n";
          key = "<leader>ds";
          action.__raw = "require('telescope.builtin').lsp_document_symbols";
        }
        {
          mode = "n";
          key = "<leader>ws";
          action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
        }
        {
          mode = "n";
          key = "<leader>K";
          action.__raw = "vim.lsp.buf.hover";
        }
        {
          mode = "n";
          key = "<leader>k";
          action.__raw = "vim.lsp.buf.signature_help";
        }

        {
          mode = "n";
          key = "<leader>gD";
          action.__raw = "vim.lsp.buf.declaration";
        }
        {
          mode = "n";
          key = "<leader>wa";
          action.__raw = "vim.lsp.buf.add_workspace_folder";
        }
        {
          mode = "n";
          key = "<leader>wr";
          action.__raw = "vim.lsp.buf.remove_workspace_folder";
        }
        {
          mode = "n";
          key = "<leader>wl";
          action.__raw = "function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end";
        }
      ];
    };
  };
}
