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
