{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.trident.zsh;
in {
  options.trident.zsh = {
    enable = lib.mkEnableOption "activate zsh";
  };
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions;
        }
        {
          name = "zsh-autocomplete";
          src = pkgs.zsh-autocomplete;
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.zsh-syntax-highlighting;
        }
        {
          name = "zsh-you-should-use";
          src = pkgs.zsh-you-should-use;
        }
        {
          name = "zsh-fzf-tab";
          src = pkgs.zsh-fzf-tab;
        }
        {
          name = "zsh-autopair";
          src = pkgs.zsh-autopair;
        }
        {
          name = "zsh-history-substring-search";
          src = pkgs.zsh-history-substring-search;
        }
        {
          name = "zsh-completions";
          src = pkgs.zsh-completions;
        }
        {
          name = "zsh-abbr";
          src = pkgs.zsh-abbr;
        }
        {
          name = "zsh-autosuggestions-abbreviations-strategy";
          src = pkgs.zsh-autosuggestions-abbreviations-strategy;
        }
        {
          name = "zsh-nix-shell";
          src = pkgs.zsh-nix-shell;
        }
        {
          name = "zsh-forgit";
          src = pkgs.zsh-forgit;
        }
      ];
      shellAliases = {
        nix-switch = "sudo nixos-rebuild switch --flake $HOME/.dotfiles";
        nix-boot = "sudo nixos-rebuild boot --flake $HOME/.dotfiles";
        nix-clean = "sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old";

        v = "nvim";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../../";

        lal = "ll -a";
        ll = "ls -lh";
        la = "ls -ah";

        ":q" = "exit";
        ssh = "TERM=xterm-256color ssh";

        nix-shell = "nix-shell --command zsh";
        rm = "coffin";
        cd = "z";
        cat = "bat";

        nd = "nix develop --command zsh";
      };
      history = {
        size = 100000;
        save = 100000;
        ignoreSpace = true;
        share = true;
      };
    };
    programs.starship.enable = true;
    # smart cd
    programs.zoxide.enable = true;
    # nicer ls
    programs.eza = {
      enable = true;
      colors = "always";
      icons = "always";
      git = true;
    };
    # significantly improved bat
    programs.bat.enable = true;
    # fuzzy find
    programs.fzf.enable = true;
    home.packages = with pkgs; [
      # better & faster grep
      ripgrep-all
      # better find
      fd
      # ;)
      inputs.coffin.packages.${pkgs.system}.coffin
    ];
  };
}
