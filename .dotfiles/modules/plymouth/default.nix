{
  lib,
  config,
  ...
}: let
  cfg = config.trident.plymouth;
in {
  options.trident.plymouth.enable = lib.mkEnableOption "activate plymouth";
  config = lib.mkIf cfg.enable {
    boot = {
      plymouth = {
        enable = true;
        theme = "bgrt";
      };
      loader.timeout = 0;
    };
  };
}
