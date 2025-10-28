{
  pkgs,
  nixvim,
  config,
  lib,
  ...
}: let
  cfg = config.trident.neovim;
in {
  imports = [
    ./colorscheme.nix
    ./plugins
    ./keybinds.nix
    ./options.nix
  ];
  options.trident.neovim = {
    enable = lib.mkEnableOption "activate neovim";
  };
  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      MANPAGER = "nvim -c 'Man!' -";
    };
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      performance = {
        byteCompileLua = {
          enable = true;
          plugins = true;
          nvimRuntime = true;
          luaLib = true;
        };

        combinePlugins = {};
      };
    };
  };
}
