{
  config,
  lib,
  ...
}: let
  cfg = config.trident.kitty;
in {
  options.trident.kitty = {
    enable = lib.mkEnableOption "activate kitty";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.TERMINAL = "kitty";
    programs.kitty = {
      enable = true;
      settings = {
        window_padding_width = 6;
        cursor_trail = 5;
        cursor_blink_interval = 0.8;
        background_opacity = "0.75";
        cursor_shape = "beam";
      };
    };
  };
}
