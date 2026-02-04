# Shell and shell-related tool configurations
{ config, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isDarwin;

in
{
  programs = {
    # Core shell configuration
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;

      shellAliases = {
        "gcm" = "git commit -m";
        "gca" = "git commit --amend --no-edit";
        "gpf" = "git push --force-with-lease";
      };

      initContent = ''
        # Initialize completion system
        zstyle ':completion:*' menu select
        zmodload zsh/complist

        # Enable vim mode
        bindkey -v
        export KEYTIMEOUT=1

        # Tab triggers completion in insert mode
        bindkey -M viins '^I' expand-or-complete

        # In menu: Tab/Enter/Ctrl-y accepts, Ctrl-e cancels
        bindkey -M menuselect '^I' accept-line
        bindkey -M menuselect '^M' accept-line
        bindkey -M menuselect '^Y' accept-line
        bindkey -M menuselect '^E' send-break

        # Use vim keys in completion menu
        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'l' vi-forward-char
        bindkey -M menuselect 'j' vi-down-line-or-history

        # Ctrl-n/Ctrl-p navigate completion menu or history
        bindkey -M menuselect '^N' down-line-or-history
        bindkey -M menuselect '^P' up-line-or-history
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
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
