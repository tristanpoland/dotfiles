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
  };
}
