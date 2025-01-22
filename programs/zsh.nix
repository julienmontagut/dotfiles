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
