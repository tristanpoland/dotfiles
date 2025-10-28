{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.waybar;
in {
  options.trident.waybar = {
    enable = lib.mkEnableOption "activate waybar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      style = ''
        @define-color background-darker rgba(30, 31, 41, 230);
        @define-color background #282a36;
        @define-color selection #44475a;
        @define-color foreground #f8f8f2;
        @define-color comment #6272a4;
        @define-color cyan #8be9fd;
        @define-color green #50fa7b;
        @define-color orange #ffb86c;
        @define-color pink #ff79c6;
        @define-color purple #bd93f9;
        @define-color red #ff5555;
        @define-color yellow #f1fa8c;
        * {
          border: none;
          border-radius: 0;
          font-family: Iosevka;
          font-size: 8pt;
          min-height: 0;
        }
        window#waybar {
          opacity: 0.9;
          background: @background-darker;
          color: @foreground;
          border-bottom: 2px solid @background;
        }
        #workspaces button {
          padding: 0 10px;
          background: @background;
          color: @foreground;
        }
        #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
          background-image: linear-gradient(0deg, @selection, @background-darker);
        }
        #workspaces button.focused,
        #workspaces button.active {
          background-image: linear-gradient(0deg, @purple, @selection);
        }
        #workspaces button.urgent {
          background-image: linear-gradient(0deg, @red, @background-darker);
        }
        #taskbar button.active {
          background-image: linear-gradient(0deg, @selection, @background-darker);
        }
        #clock {
          padding: 0 4px;
          background: @background;
        }
      '';
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 24;
          spacing = 5;
          modules-left = [
            "hyprland/window"
          ];
          modules-center = [
            "hyprland/workspaces"
          ];
          modules-right = [
            "tray"
            "network"
            "pulseaudio"
            "mpris"
            "bluetooth"
            "battery"
            "clock"
          ];
          "hyprland/workspaces" = {
            persistent-workspaces = {
              "*" = 9;
            };
          };
          clock = {
            format = "{:%A %B %d %H:%M %p}";
          };
          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-etheret = "{ifname}";
            format-disconnected = "Disconnected ⚠ {ifname}";
          };
          bluetooth = {
            format-connected = "{device-alias} - {status}";
            format-connected-battery = "{device_alias} - {status} ({device_battery_percentage}% charged)";
            format-disabled = "";
            on-click = "${lib.getExe pkgs.blueman}";
          };
          pulseaudio = {
            scroll-step = 5;
            format = "{icon}  {volume}% {format_source}";
            format-bluetooth = " {icon} {volume}% {format_source}";
            format-bluetooth-muted = "  {icon} {format_source}";
            format-muted = "  {format_source}";
            format-source = " {volume}%";
            format-source-muted = "";
            format-icons = {
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "${lib.getExe pkgs.pavucontrol}";
          };
          mpris = {
            format = "DEFAULT: {player_icon} {title}";
            format-paused = "DEFAULT: {status_icon} <i>{dynamic}</i>";
            player-icons = {
              default = "▶";
            };
            status-icons = {
              paused = "⏸";
            };
          };
        };
      };
    };
  };
}
