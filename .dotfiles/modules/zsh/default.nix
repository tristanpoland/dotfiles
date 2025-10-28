{
  lib,
  config,
  ...
}: let
  cfg = config.trident.zsh;
in {
  options.trident.zsh.enable = lib.mkEnableOption "activate zsh";
  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
  };
}
