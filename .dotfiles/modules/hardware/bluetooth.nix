{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.trident.bluetooth;
in {
  options.trident.bluetooth.enable = lib.mkEnableOption "activate bluetooth support";

  config = lib.mkIf cfg.enable {
    services.udev.packages = [pkgs.headsetcontrol];
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };
}
