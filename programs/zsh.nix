# Shell and shell-related tool configurations
{ pkgs, ... }:

{
  programs = {
    # Core shell configuration
    zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;

      initExtra = ''
        # Initialize completion system
        zstyle ':completion:*' menu select
        zmodload zsh/complist

        # Enable vim mode
        bindkey -v
        export KEYTIMEOUT=1

        # Use vim keys in tab complete menu (both insert and normal mode)
        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'l' vi-forward-char
        bindkey -M menuselect 'j' vi-down-line-or-history

        # Accept completion with more convenient keys
        bindkey -M menuselect '^Y' accept-line
        bindkey -M menuselect 'Tab' accept-line

        # Better history search with Ctrl-p and Ctrl-n (both insert and normal mode)
        bindkey -M viins '^P' history-substring-search-up
        bindkey -M viins '^N' history-substring-search-down
        bindkey -M vicmd '^P' history-substring-search-up
        bindkey -M vicmd '^N' history-substring-search-down

        # History substring search with up/down keys
        bindkey -M viins '^[[A' history-substring-search-up
        bindkey -M viins '^[[B' history-substring-search-down
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
      '';
    };

    # Directory environment management
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    # Shell prompt
    starship.enable = true;

    # Modern alternatives to classic Unix commands
    eza = {
      enable = true;
      icons = "auto";
    };
    bat = {
      enable = true;
      config.theme = "ansi";
    };

    # Search and navigation tools
    fzf.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    yazi = {
      enable = true;
      settings = {
        manager = {
          showHidden = true;
          ratio = [ 1 2 2 ];
        };
      };
    };
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
