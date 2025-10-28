{
  lib,
  config,
  ...
}: let
  cfg = config.trident.secureboot;
in {
  options.trident.secureboot.enable = lib.mkEnableOption "activate plymouth";
  config = lib.mkIf cfg.enable {
    boot = {
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
  };
}
