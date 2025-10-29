{
  flake-self,
  pkgs,
  config,
  lib,
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


  # Lenovo Legion 7i Slim + Audio utilities
  environment.systemPackages = with pkgs; [
    wireguard-tools
    pavucontrol
    gnome-keyring
    libsecret
    pulseaudio
    alsa-utils
  ];

  # ALLOW PIPEWIRE FOR SCREEN SHARING BUT NOT AUDIO
  # PipeWire can handle video/screenshare while PulseAudio handles audio
  services.pipewire = {
    enable = true;
    # EXPLICITLY DISABLE ALL AUDIO FUNCTIONALITY
    audio.enable = false;
    alsa.enable = false;
    pulse.enable = false;
    jack.enable = false;
    # Only allow video/screenshare functionality
    wireplumber.enable = true;
  };

  # FORCE PULSEAUDIO FOR ALL AUDIO - NO EXCEPTIONS
  services.pulseaudio = {
    enable = lib.mkForce true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  # BOOT SCRIPT - ALLOW PIPEWIRE FOR VIDEO, PULSEAUDIO FOR AUDIO
  # This handles screen sharing while keeping stable audio
  systemd.services.fix-audio = {
    description = "Configure PipeWire for video only, PulseAudio for audio";
    wantedBy = [ "multi-user.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "fix-audio" ''
        # Kill only PipeWire AUDIO services (keep video functionality)
        ${pkgs.systemd}/bin/systemctl --user stop pipewire-pulse 2>/dev/null || true
        ${pkgs.procps}/bin/pkill -f "pipewire-pulse" || true
        
        # Remove PipeWire AUDIO configs but keep video configs
        rm -rf /home/*/.config/pipewire/pipewire-pulse.conf* || true
        
        # Ensure PulseAudio is running for all users
        for user_home in /home/*; do
          if [ -d "$user_home" ]; then
            user=$(basename "$user_home")
            ${pkgs.sudo}/bin/sudo -u "$user" ${pkgs.pulseaudio}/bin/pulseaudio --kill 2>/dev/null || true
            ${pkgs.sudo}/bin/sudo -u "$user" ${pkgs.pulseaudio}/bin/pulseaudio --start --daemonize 2>/dev/null || true
          fi
        done
        
        # Wait for PulseAudio to initialize
        sleep 3
        
        # Auto-detect and configure audio devices
        for user_home in /home/*; do
          if [ -d "$user_home" ]; then
            user=$(basename "$user_home")
            
            # List all available sinks and sources
            echo "=== Audio Devices for $user ==="
            ${pkgs.sudo}/bin/sudo -u "$user" ${pkgs.pulseaudio}/bin/pactl list short sinks 2>/dev/null || true
            ${pkgs.sudo}/bin/sudo -u "$user" ${pkgs.pulseaudio}/bin/pactl list short sources 2>/dev/null || true
            
            # Set default internal audio (fallback)
            ${pkgs.sudo}/bin/sudo -u "$user" ${pkgs.pulseaudio}/bin/pactl set-default-source alsa_input.pci-0000_00_1f.3.analog-stereo 2>/dev/null || true
            ${pkgs.sudo}/bin/sudo -u "$user" ${pkgs.pulseaudio}/bin/pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo 2>/dev/null || true
            
            # Auto-detect and prefer USB/external devices if available
            usb_sink=$(${pkgs.sudo}/bin/sudo -u "$user" ${pkgs.pulseaudio}/bin/pactl list short sinks 2>/dev/null | grep -i "usb\|headset\|wireless" | head -1 | cut -f2)
            if [ -n "$usb_sink" ]; then
              echo "Found external audio device: $usb_sink"
              ${pkgs.sudo}/bin/sudo -u "$user" ${pkgs.pulseaudio}/bin/pactl set-default-sink "$usb_sink" 2>/dev/null || true
            fi
            
            usb_source=$(${pkgs.sudo}/bin/sudo -u "$user" ${pkgs.pulseaudio}/bin/pactl list short sources 2>/dev/null | grep -i "usb\|headset\|wireless" | head -1 | cut -f2)
            if [ -n "$usb_source" ]; then
              echo "Found external microphone: $usb_source"
              ${pkgs.sudo}/bin/sudo -u "$user" ${pkgs.pulseaudio}/bin/pactl set-default-source "$usb_source" 2>/dev/null || true
            fi
          fi
        done
        
        echo "Audio: PulseAudio, Video: PipeWire - Setup complete!"
      '';
    };
  };

  # USB AUDIO DEVICE HOT-PLUG DETECTION
  # Automatically switch to USB headsets when plugged in
  services.udev.extraRules = ''
    # USB Audio devices - trigger audio reconfiguration
    SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="01", ACTION=="add", RUN+="${pkgs.systemd}/bin/systemctl restart fix-audio.service"
    SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="01", ACTION=="remove", RUN+="${pkgs.systemd}/bin/systemctl restart fix-audio.service"
    
    # Audio devices - trigger reconfiguration  
    SUBSYSTEM=="sound", ACTION=="add", RUN+="${pkgs.systemd}/bin/systemctl restart fix-audio.service"
    SUBSYSTEM=="sound", ACTION=="remove", RUN+="${pkgs.systemd}/bin/systemctl restart fix-audio.service"
  '';

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
    system.bash.enable = true;
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
