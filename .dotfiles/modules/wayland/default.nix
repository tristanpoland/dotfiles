{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.trident.wayland;
in {
  options.trident.wayland.enable = lib.mkEnableOption "activate wayland";
  config = lib.mkIf cfg.enable {
    programs.xwayland.enable = true;
    environment.systemPackages = with pkgs; [
      wl-clipboard-rs
      xwayland
      kdePackages.xwaylandvideobridge
      wayland-utils
      wev
    ];
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QUICK_CONTROLS_STYLE = "org.kde.desktop";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland;xcb";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland,x11";
    };
    services.dbus.enable = true;
    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };
  };
}
