{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.gtk;
in {
  options.trident.gtk = {
    enable = lib.mkEnableOption "activate gtk";
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        package = pkgs.dracula-theme;
        name = "Dracula";
      };
    };
  };
}
