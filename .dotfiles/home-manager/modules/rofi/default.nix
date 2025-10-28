{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.rofi;
in {
  options.trident.rofi = {
    enable = lib.mkEnableOption "activate rofi";
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [
        rofi-calc
        rofi-network-manager
        rofi-bluetooth
        rofi-file-browser
        rofi-emoji
      ];
    };
  };
}
