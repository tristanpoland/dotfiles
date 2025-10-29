{
  lib,
  config,
  ...
}: let
  cfg = config.trident.system.bash;
in {
  options.trident.system.bash.enable = lib.mkEnableOption "enable bash system configuration";
  config = lib.mkIf cfg.enable {
    programs.bash.enable = true;
    
    # Set bash as the default shell system-wide
    environment.shells = [ "/run/current-system/sw/bin/bash" ];
    users.defaultUserShell = "/run/current-system/sw/bin/bash";
    
    # Enable bash completion
    programs.bash.enableCompletion = true;
  };
}