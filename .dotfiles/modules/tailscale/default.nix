{
  lib,
  config,
  ...
}: let
  cfg = config.trident.tailscale;
in {
  options.trident.tailscale.enable = lib.mkEnableOption "activate tailscale";
  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
    };
  };
}
