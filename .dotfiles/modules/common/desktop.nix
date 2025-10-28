{
  lib,
  config,
  ...
}: let
  cfg = config.trident.desktop;
in {
  options.trident.desktop = {
    enable = lib.mkEnableOption "activate desktop";
    wayland.enable = true;
  };

  config = lib.mkIf cfg.enable {
    programs = {
      dconf.enable = true;
      ssh = {
        enableAskPassword = true;
      };
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      audio.enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
