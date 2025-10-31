{ config, lib, pkgs, ... }:

let
  cfg = config.trident.nvidia;
in
{
  options.trident.nvidia = {
    enable = lib.mkEnableOption "Enable NVIDIA GPU support";
    useOpenDrivers = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use open NVIDIA drivers instead of proprietary ones";
    };
    nvidiaBusId = lib.mkOption {
      type = lib.types.str;
      description = "PCI Bus ID of the NVIDIA GPU (optional)";
    };
    intelBusId = lib.mkOption {
      type = lib.types.str;
      description = "PCI Bus ID of the Intel iGPU (optional)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable NVIDIA video driver in X
    services.xserver.videoDrivers = [ "nvidia" ];

      # Force NVIDIA as primary GPU for X11 (disable PRIME offloading)
      services.xserver.deviceSection = ''
        Option "AllowEmptyInitialConfiguration"
        Option "UseDisplayDevice" "None"
        Option "PrimaryGPU" "Yes"
        Option "BusID" "${cfg.nvidiaBusId}"
      '';

      # For Wayland (e.g., Hyprland, Sway), set environment variables to force NVIDIA usage
      environment.sessionVariables = {
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __NV_PRIME_RENDER_OFFLOAD = "0";
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "";
        __GL_PRIME_RENDER_OFFLOAD = "0";
        __GL_PRIME_RENDER_OFFLOAD_PROVIDER = "";
        CUDA_VISIBLE_DEVICES = "0";
      };

    hardware.nvidia = {
      modesetting.enable = true;
      open = cfg.useOpenDrivers;
      nvidiaSettings = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Ensure NVIDIA modules load early
    boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

    # Kernel parameters for suspend/resume
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      "mem_sleep_default=deep"
    ];

    # Temporary directory for NVIDIA driver
    systemd.tmpfiles.rules = [
      "d /var/tmp 1777 root root"
    ];
  };
}
