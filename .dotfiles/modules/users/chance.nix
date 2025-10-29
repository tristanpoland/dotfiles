{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.trident.users.trident;
in {
  options.trident.users.trident.enable = lib.mkEnableOption "activate user trident";
  config = lib.mkIf cfg.enable {
    users.users.trident = {
      home = "/home/trident";
      isNormalUser = true;
      password = "nixos";
      extraGroups = ["wheel" "docker"] ++ lib.optionals config.networking.networkmanager.enable ["networkmanager"];
      shell = pkgs.bash;
    };
  };
}
