{
  flake-self,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

#  systemd.services."nvidia-resume-fix" = {
#  description = "Rebind NVIDIA driver and restart display-manager after resume";
#  wantedBy = [ "post-resume.target" ];
#  after = [ "systemd-suspend.service" "systemd-hibernate.service" ];
#  serviceConfig = {
#    Type = "oneshot";
#    ExecStart = pkgs.writeShellScript "nvidia-resume-fix" ''
#      #!/bin/sh
#      echo "[nvidia-resume-fix] Rebinding NVIDIA modules..."
#      modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
#      modprobe nvidia nvidia_uvm nvidia_modeset nvidia_drm
#      echo "[nvidia-resume-fix] Restarting display-manager..."
#      systemctl restart display-manager
#    '';
#  };
#};


  # Lenovo Legion 7i Slim Mic feedback fix
  environment.systemPackages = with pkgs; [
    wireguard-tools
    pavucontrol
    gnome-keyring
    libsecret
  ];

  # Enable PipeWire with echo cancellation
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    # Load the echo-cancel module by default (uses WebRTC AEC)
    extraConfig.pipewire-pulse = {
      "10-echo-cancel.conf" = {
        "context.modules" = [
          {
            name = "libpipewire-module-echo-cancel";
            args = {
              "aec.method" = "webrtc";
              "source.props" = {
                "node.name" = "echoCancelSource";
                "node.description" = "Echo-Cancelled Microphone";
              };
              "sink.props" = {
                "node.name" = "echoCancelSink";
                "node.description" = "Echo-Cancelled Output";
              };
            };
          }
        ];
      };
    };
  };

  # Disable legacy PulseAudio
  services.pulseaudio.enable = false;

  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];

  trident = {
    secureboot.enable = false;
    users.trident.enable = true;
    common.enable = true;
    tailscale.enable = true;
    bluetooth.enable = true;
    desktop.plasma.enable = true;
    desktop.hyprland.enable = false;
    desktop.enable = true;
    sddm.enable = true;
    plymouth.enable = true;
    zsh.enable = true;
    laptop.enable = true;

    nvidia = {
      enable = true;
      useOpenDrivers = false;
#      nvidiaBusId = "PCI:1:0:0";
#      intelBusId = "PCI:0:2:0";
    };


    gaming.steam.enable = true;

    docker = {
      enable = true;
      rootlessDaemon = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

  networking = {
    hostName = "BlueMachine";
    networkmanager = {
      enable = true;
      wifi.macAddress = "stable";
    };
  };

  home-manager.users.trident = flake-self.homeConfigurations.trident;
}
