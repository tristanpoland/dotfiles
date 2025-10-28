{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.zed;
in {
  options.trident.zed = {
    enable = lib.mkEnableOption "activate zed";
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "toml"
        "dracula"
        "gleam"
        "zig"
        "astro"
        "c#"
        "git-firefly"
      ];
      extraPackages = [pkgs.nixd pkgs.nil];
      userSettings = {
        theme = "Dracula";
        inlay_hints = {
          enabled = true;
        };
        auto_update = false;
        languages = {
          Markdown = {
            formatter = "prettier";
          };
          JSON = {
            formatter = "prettier";
          };
          TOML = {
            formatter = "taplo";
          };
          Nix = {
            formatter = {
              external = {
                command = "nix";
                arguments = ["fmt" "."];
              };
            };
          };
        };
        lsp = {
          "rust-analyzer" = {
            binary = {
              path = "${lib.getExe pkgs.rust-analyzer}";
            };
            settings = {
              diagnostics = {
                enable = true;
                styleLints = {
                  enable = true;
                };
              };
              checkOnSave = true;
              check = {
                command = "clippy";
                features = "all";
              };
              cargo = {
                buildScripts = {
                  enable = true;
                };
                features = "all";
              };
              inlayHints = {
                bindingModeHints = {
                  enable = true;
                };
                closureStyle = "rust_analyzer";
                closureReturnTypeHints = {
                  enable = "always";
                };
                discriminantHints = {
                  enable = "always";
                };
                expressionAdjustmentHints = {
                  enable = "always";
                };
                implicitDrops = {
                  enable = true;
                };
                lifetimeElisionHints = {
                  enable = "always";
                };
                rangeExclusiveHints = {
                  enable = true;
                };
              };
              procMacro = {
                enable = true;
              };
              rustc = {
                source = "discover";
              };
              files = {
                excludeDirs = [
                  ".cargo"
                  ".direnv"
                  ".git"
                  "node_modules"
                  "target"
                ];
              };
            };
          };
        };
      };
    };
  };
}
