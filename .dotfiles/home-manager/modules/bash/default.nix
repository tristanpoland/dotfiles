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
        # Color definitions
        RED='\[\e[0;31m\]'
        GREEN='\[\e[0;32m\]'
        YELLOW='\[\e[0;33m\]'
        BLUE='\[\e[0;34m\]'
        PURPLE='\[\e[0;35m\]'
        CYAN='\[\e[0;36m\]'
        WHITE='\[\e[0;37m\]'
        RESET='\[\e[0m\]'
        
        # Git prompt function
        git_prompt() {
          local git_status=""
          local git_branch=""
          
          if git rev-parse --git-dir > /dev/null 2>&1; then
            git_branch=$(git branch 2>/dev/null | grep '^\*' | cut -d' ' -f2-)
            
            if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
              git_status="$RED*"
            else
              git_status="$GREEN✓"
            fi
            
            echo " $PURPLE($CYAN$git_branch$git_status$PURPLE)"
          fi
        }
        
        # Set the prompt
        PS1="$GREEN\u$RESET@$BLUE\h$RESET:$YELLOW\w$RESET\$(git_prompt)$WHITE\$ $RESET"
        
        # Better history
        export HISTSIZE=10000
        export HISTFILESIZE=20000
        export HISTCONTROL=ignoredups:erasedups
        shopt -s histappend
        
        # Better tab completion
        bind 'set completion-ignore-case on'
        bind 'set show-all-if-ambiguous on'
        bind 'set completion-map-case on'
        
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
        rm = "coffin";
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
      # coffin is already in your inputs
    ];
  };
}