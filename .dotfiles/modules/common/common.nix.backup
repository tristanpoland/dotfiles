{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.common;
in {
  options.trident.common.enable = lib.mkEnableOption "activate common";
  config = lib.mkIf cfg.enable {
    boot = {
      tmp.useTmpfs = lib.mkDefault true;
      tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);
      kernel.sysctl = {
        "vm.swappiness" = 1;
        "fs.suid_dumpable" = 0;
        "kernel.yama.ptrace_scope" = 1;
        "kernel.kexec_load_disabled" = 1;
        "fs.protected_hardlinks" = 1;
        "fs.protected_symlinks" = 1;
      };
    };
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    security.sudo.enable = false;
    security.sudo-rs = {
      enable = true;
      execWheelOnly = false;
    };
    services.openssh.enable = true;
    environment.systemPackages = with pkgs; [
      (lib.hiPrio uutils-coreutils-noprefix)
      git
    ];
    environment.shells = with pkgs; [bash];
  };
}
