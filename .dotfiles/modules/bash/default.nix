{
  lib,
  config,
  ...
}: let
  cfg = config.trident.bash;
in {
  options.trident.bash.enable = lib.mkEnableOption "activate bash";
  config = lib.mkIf cfg.enable {
    programs.bash.enable = true;
    
    # Set bash as the default shell system-wide
    environment.shells = [ "/run/current-system/sw/bin/bash" ];
    
    # Enable bash completion
    programs.bash.enableCompletion = true;
  };
}