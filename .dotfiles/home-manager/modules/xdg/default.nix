{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.xdg;
in {
  options.trident.xdg = {
    enable = lib.mkEnableOption "activate xdg";
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;
      portal = {
        extraPortals = with pkgs; [
          kdePackages.xdg-desktop-portal-kde
        ];
      };
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = ["nvim.desktop"];
          "text/css" = ["nvim.desktop"];
          "text/csv" = ["nvim.desktop"];
          "text/markdown" = ["nvim.desktop"];
          "text/plain" = ["nvim.desktop"];
          "text/x-c" = ["nvim.desktop"];
          "text/x-asm" = ["nvim.desktop"];
          "text/x-python" = ["nvim.desktop"];
        };
      };
      configFile = {
        "mimeapps.list".force = true;
      };
    };
  };
}
