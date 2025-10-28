{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.trident.desktop.plasma;
in {
  options.trident.desktop.plasma = {
    enable = lib.mkEnableOption "activate plasma";
    softwareCursor = lib.mkEnableOption "force software cursors";
    kdeConnect = lib.mkEnableOption "activate kdeConnect";
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services = {
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };
        desktopManager.plasma6.enable = true;
      };
    })
    (lib.mkIf (cfg.enable && cfg.softwareCursor) {
      environment.sessionVariables.KWIN_FORCE_SW_CURSOR = 1;
    })
    (lib.mkIf (cfg.enable && cfg.kdeConnect) {
      programs.kdeconnect = {
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        kdePackages.krdc
        kdePackages.krfb
      ];
    })
  ];
}
