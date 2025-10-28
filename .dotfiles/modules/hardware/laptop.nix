{
  config,
  lib,
  ...
}: let
  cfg = config.trident.laptop;
in {
  options.trident.laptop.enable = lib.mkEnableOption "activate laptop hardware";

  config = lib.mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop = {
        enable = true;
      };
    };

    services = {
      libinput.enable = true;
      thermald.enable = true;
      power-profiles-daemon.enable = true;
    };

    systemd.sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowHybridSleep=yes
      AllowSuspendThenHibernate=yes
    '';
  };
}
