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
    # Audio configuration moved to machine-specific config
    # 
    # NOTE: Audio is configured per-machine because different hardware
    # requires different setups. Current options:
    #
    # Option 1 - PulseAudio (Most Stable):
    # services.pulseaudio = {
    #   enable = true;
    #   support32Bit = true;
    #   package = pkgs.pulseaudioFull;
    #   extraConfig = ''
    #     set-default-source alsa_input.pci-0000_00_1f.3.analog-stereo
    #     set-source-port alsa_input.pci-0000_00_1f.3.analog-stereo analog-input-internal-mic
    #   '';
    # };
    # services.pipewire.enable = false;
    #
    # Option 2 - Simple PipeWire (Modern):
    # services.pipewire = {
    #   enable = true;
    #   alsa = { enable = true; support32Bit = true; };
    #   pulse.enable = true;
    #   wireplumber.enable = true;
    # };
    # services.pulseaudio.enable = false;
    #
    # Avoid echo cancellation modules - they often cause more problems than they solve!
  };
}
