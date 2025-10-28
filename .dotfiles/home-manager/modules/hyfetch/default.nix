{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.hyfetch;
in {
  options.trident.hyfetch = {
    enable = lib.mkEnableOption "activate hyfetch";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      fastfetch
    ];
    programs.hyfetch = {
      enable = true;
      settings = {
        preset = "gay-men";
        backend = "fastfetch";
        pride_month_disable = false;
        mode = "rgb";
        color_align = {
          mode = "horizontal";
        };
      };
    };
  };
}
