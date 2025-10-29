{
  config,
  lib,
  ...
}: let
  cfg = config.trident.git;
in {
  options.trident.git = {
    enable = lib.mkEnableOption "activate git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      extraConfig = {
        user = {
          name = "trident";
          email = "redstonecrafter126@@gmail.com";
        #  signingKey = "Trident_For_U";
        };
        #commit.gpgsign = true;
        init.defaultBranch = "main";
        merge = {
          ff = "no";
          no-commit = "yes";
        };
        pull.ff = "only";
        push = {autoSetupRemote = true;};
      };
    };
  };
}
