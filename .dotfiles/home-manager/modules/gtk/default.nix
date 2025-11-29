{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.gtk;
in {
  options.trident.gtk = {
    enable = lib.mkEnableOption "activate gtk";
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        package = pkgs.dracula-theme;
        name = "Dracula";
      };
    };
    home.activation.removeGtkrcBackups = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      rm -f "$HOME/.gtkrc-2.0.*.bkp"
    '';
  };
}
