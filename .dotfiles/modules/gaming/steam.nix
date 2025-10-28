{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.trident.gaming.steam;
in {
  options.trident.gaming.steam = {
    enable = lib.mkEnableOption "activate steam";
    allowNetworkTransfers = lib.mkOption {
      type = lib.types.bool;
      description = "Opens the firewall to allow steam to transfer games accrossed the network";
      default = false;
    };
    allowRemotePlay = lib.mkOption {
      type = lib.types.bool;
      description = "Opens the firewall to allow remote computers to connect to this device for Steam remote-play";
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;

      localNetworkGameTransfers.openFirewall = cfg.allowNetworkTransfers;
      remotePlay.openFirewall = cfg.allowRemotePlay;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
