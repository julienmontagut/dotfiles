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
        # Use vim keys in tab complete menu
        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'l' vi-forward-char
        bindkey -M menuselect 'j' vi-down-line-or-history

        # Accept completion with more convenient keys
        bindkey -M menuselect '^Y' accept-line
        bindkey -M menuselect 'Tab' accept-line

        # Better history search with Ctrl-p and Ctrl-n
        bindkey '^P' history-substring-search-up
        bindkey '^N' history-substring-search-down

        # Use vim keys for history substring search
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down

        # Enable vim mode
        bindkey -v
        export KEYTIMEOUT=1
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
