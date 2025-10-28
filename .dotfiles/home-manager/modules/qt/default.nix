{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.qt;
in {
  options.trident.qt = {
    enable = lib.mkEnableOption "activate qt";
  };

  config = lib.mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        name = "Dracula";
        package = pkgs.dracula-qt5-theme;
      };
    };
  };
}
