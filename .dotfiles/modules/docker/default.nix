{
  lib,
  config,
  ...
}: let
  cfg = config.trident.docker;
in {
  options.trident.docker = {
    enable = lib.mkEnableOption "activate docker";
    rootlessDaemon = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
        enable = true;
        storageDriver = "overlay2";
      liveRestore = true;
      rootless = {
        enable = cfg.rootlessDaemon;
        setSocketVariable = cfg.rootlessDaemon;
        daemon.settings = {
          dns = [
            "1.1.1.1"
            "1.0.0.1"
            "8.8.8.8"
            "8.8.4.4"
          ];
        };
      };
    };
  };
}
