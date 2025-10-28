{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.hyprland;
in {
  options.trident.hyprland = {
    enable = lib.mkEnableOption "activate hyprland";
    autostart = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "packages to autostart with hyprland";
    };
    extraExec = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "commands to run once at hyprland startup";
    };
    defaultBrowser = lib.mkPackageOption pkgs "browser" {
      default = pkgs.firefox;
    };
    defaultTerminal = lib.mkPackageOption pkgs "terminal" {
      default = pkgs.kitty;
    };
    defaultEditor = lib.mkPackageOption pkgs "editor" {
      default = pkgs.nano;
    };
    portal = lib.mkOption {
      type = lib.types.enum ["gtk" "qt" "none"];
      default = "gtk";
      description = "set the xdg desktop portal backend for hyprland";
    };
    defaultLauncher = lib.mkOption {
      type = lib.types.str;
      default = "${lib.getExe pkgs.rofi} -show drun";
      description = "the command to be executed when opening the program launcher";
    };
    enablePortal = lib.mkEnableOption "enable xdg-desktop-portal-hyprland";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        general = {
          "col.active_border" = "rgb(44475a) rgb(bd93f9) 90deg";
          "col.inactive_border" = "rgba(44475aaa)";
          "col.nogroup_border" = "rgba(282a36dd)";
          "col.nogroup_border_active" = "rgb(bd93f9) rgb(44475a) 90deg";
          border_size = 2;
          resize_on_border = true;
          extend_border_grab_area = 15;
          hover_icon_on_border = true;
          layout = "dwindle";
        };
        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 6;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = true;
            xray = true;
          };
          shadow = {
            enabled = true;
            color = "rgba(1E202966)";
            range = 60;
            offset = "1 2";
            render_power = 3;
            scale = 0.97;
          };
        };
        exec-once =
          [
            "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init"
            "${pkgs.networkmanagerapplet}/bin/nm-applet"
            "${pkgs.blueman}/bin/blueman-applet"
          ]
          ++ lib.map (pkg: lib.getExe pkg) cfg.autostart
          ++ cfg.extraExec;

        "$super" = "SUPER";
        "$alt_super" = "CTRL";
        bind = [
          "$super, Q, killactive,"
          "$alt_super $super,Q,exit"
          "$super, T, exec, ${lib.getExe cfg.defaultTerminal}"
          "$super, L, exec, hyprlock --immediate"
          "$super, B, exec, zen"
          "$super, F, fullscreen"
          "$super SHIFT, F, togglefloating"
          "$super, E, exec, ${lib.getExe cfg.defaultEditor}"
          "$super, W, exec, ${lib.getExe cfg.defaultBrowser}"
          "ALT, SPACE, exec, ${cfg.defaultLauncher}"
          "$super, P, pseudo,"

          "$super, 1, workspace, 1"
          "$super, 2, workspace, 2"
          "$super, 3, workspace, 3"
          "$super, 4, workspace, 4"
          "$super, 5, workspace, 5"
          "$super, 6, workspace, 6"
          "$super, 7, workspace, 7"
          "$super, 8, workspace, 8"
          "$super, 9, workspace, 9"
          "$super, 0, workspace, 10"

          "$super SHIFT, 1, movetoworkspace, 1"
          "$super SHIFT, 2, movetoworkspace, 2"
          "$super SHIFT, 3, movetoworkspace, 3"
          "$super SHIFT, 4, movetoworkspace, 4"
          "$super SHIFT, 5, movetoworkspace, 5"
          "$super SHIFT, 6, movetoworkspace, 6"
          "$super SHIFT, 7, movetoworkspace, 7"
          "$super SHIFT, 8, movetoworkspace, 8"
          "$super SHIFT, 9, movetoworkspace, 9"
          "$super SHIFT, 0, movetoworkspace, 10"

          "$super, J, togglesplit"

          "$super, left, movefocus, l"
          "$super, right, movefocus, r"
          "$super, up, movefocus, u"
          "$super, down, movefocus, d"
        ];
        bindm = [
          "$super, mouse:272, movewindow"
          "$super, mouse:273, resizewindow"
        ];
        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
        ];
      };
    };
    xdg.portal = lib.mkIf (cfg.portal != "none") {
      enable = true;
      extraPortals = with pkgs;
        [xdg-desktop-portal-hyprland]
        ++ (
          lib.optionals (cfg.portal == "gtk") [xdg-desktop-portal-gtk]
        )
        ++ (
          lib.optionals (cfg.portal == "qt") [xdg-desktop-portal-kde]
        );
    };
  };
}
