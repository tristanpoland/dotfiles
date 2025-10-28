{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.vscode;
in {
  options.trident.vscode = {
    enable = lib.mkEnableOption "activate vscode";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      #package = pkgs.vscodium;

      mutableExtensionsDir = true;
      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = true;
        userSettings = {
          "settingsSync.enable" = true;
          #          "editor.cursorSmoothCaretAnimation" = "on";
          "editor.smoothScrolling" = true;
          #          "editor.cursorBlinking" = "expand";
          "direnv.restart.automatic" = true;
          "workbench.colorTheme" = "Darcula Solid";
          "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
          "svelte.enable-ts-plugin" = true;
          "rust-analyzer" = {
            "check" = {
              "command" = "clippy";
            };
          };

          "clangd.arguments" = [
            "--clang-tidy"
            "--background-index"
            "--completion-style=detailed"
            "--cross-file-rename"
            "--header-insertion=iwyu"
            "--all-scopes-completion"
          ];
          "editor.fontFamily" = "JetBrainsMono Nerd Font";
          "zig.path" = "${pkgs.zls}/bin/zls";
          "harper.path" = "${pkgs.harper}/bin/harper-ls";
        };
      };
    };
  };
}
