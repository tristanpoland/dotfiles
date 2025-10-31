{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.trident.bash;
in {
  options.trident.bash = {
    enable = lib.mkEnableOption "activate bash";
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      
      # Nice, clean bash prompt with git info
      bashrcExtra = ''
          # If in devshell and not running bashInteractive, re-exec it for proper keybindings
          if [ -n "$IN_NIX_SHELL" ] && [ -z "$__BASH_INTERACTIVE" ]; then
            if [ -x "$(command -v bashInteractive)" ]; then
              export __BASH_INTERACTIVE=1
              exec bashInteractive
            fi
          fi
          # Unified prompt logic
          if [ -n "$IN_NIX_SHELL" ]; then
            # Devshell prompt: use raw ANSI codes for color
            PS1='\e[0;35m[DEV]\e[0m \e[0;32m\u\e[0m@\e[0;34m\h\e[0m:\e[0;33m\w\e[0m $ '
          else
            # Normal prompt: use non-printing escapes for proper wrapping
            PS1='\[\e[0;32m\]\u\[\e[0m\]@\[\e[0;34m\]\h\[\e[0m\]:\[\e[0;33m\]\w\[\e[0m\] $ '
          fi

          # Better history
          export HISTSIZE=10000
          export HISTFILESIZE=20000
          export HISTCONTROL=ignoredups:erasedups
          if type shopt &>/dev/null; then shopt -s histappend; fi

          # Better tab completion
          if type bind &>/dev/null; then
            bind 'set completion-ignore-case on'
            bind 'set show-all-if-ambiguous on'
            bind 'set completion-map-case on'
          fi

          # Colorful ls
          alias ls='ls --color=auto'
          alias grep='grep --color=auto'
      '';
      
      # Shell aliases (same as your zsh ones)
      shellAliases = {
        # Nix aliases
        nix-switch = "/run/wrappers/bin/sudo nixos-rebuild switch --flake $HOME/.dotfiles";
        nix-boot = "/run/wrappers/bin/sudo nixos-rebuild boot --flake $HOME/.dotfiles";
        nix-clean = "/run/wrappers/bin/sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old";
        
        # Navigation shortcuts
        v = "nvim";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../../";
        
        # Listing aliases
        lal = "ll -a";
        ll = "ls -lh";
        la = "ls -ah";
        
        # Misc aliases
        ":q" = "exit";
        ssh = "TERM=xterm-256color ssh";
        # rm = "coffin";
        cd = "z";
        cat = "bat";
        nd = "nix develop --command bash";
      };
      
      # History settings
      historySize = 100000;
      historyFileSize = 100000;
      historyControl = [ "ignoredups" "erasedups" ];
    };
    
    # Keep the useful tools from your zsh config
    programs.zoxide.enable = true;  # smart cd
    programs.eza = {                # nicer ls
      enable = true;
      colors = "always";
      icons = "always";
      git = true;
    };
    programs.bat.enable = true;     # better cat
    programs.fzf.enable = true;     # fuzzy find
    
    home.packages = with pkgs; [
      ripgrep-all   # better grep
      fd            # better find
      #coffin        # safer rm
    ];
  };
}