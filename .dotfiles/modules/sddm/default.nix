{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.trident.sddm;
in {
  options.trident.sddm = {
    enable = lib.mkEnableOption "activate sddm";
  };
  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
