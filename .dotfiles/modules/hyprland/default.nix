{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.trident.desktop.hyprland;
in {
  options.trident.desktop.hyprland = {
    enable = lib.mkEnableOption "activate plasma";
  };
  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
  };
}
