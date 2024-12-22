# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, lib, config, pkgs, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "julien";
    homeDirectory =
      if isDarwin then
        "/Users/julien"
      else
        "/home/julien";
  };

  xdg.enable = true;

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # programs.wezterm.enable = true;
  # programs.wezterm.enableZshIntegration = true;
  home.packages = with pkgs; [
    bat
    devenv
    eza
    fd
    fzf
    gh
    gleam
    just
    lazygit
    lua
    neovim
    ollama
    ripgrep
    yazi
  ];

  # fonts.fontConfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    antidote = {
      enable = true;
      plugins = [
        "sindresorhus/pure"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"
        "zdharma-continuum/fast-syntax-highlighting"
      ];
    };
  };
  programs.bat = {
    enable = true;
    config.theme = "ansi";
  };
  # TODO: Bind config from the repo to xdg
  # programs.firefox = {
  #   enable = true;
  #   package = null;
  #   profiles = {
  #     home = {
  #       isDefault = true;
  #       settings = {
  #         # "browser.startup.homepage" = "https://duckduckgo.com";
  #         "browser.search.defaultenginename" = "DuckDuckGo";
  #         "browser.search.order.1" = "DuckDuckGo";
  #         "extensions.autoDisableScopes" = 0;
  #       };
  #       search = {
  #         default = "DuckDuckGo";
  #         order = [ "DuckDuckGo" ];
  #       };
  #       extensions = with nur.repos.rycee.firefox-addons; [
  #         adguard-adblocker
  #         proton-pass
  #         icloud-passwords
  #       ];
  #     };
  #   };
  # };

  xdg.configFile = {
    "nvim".source = ./config/nvim;
    "wezterm".source = ./config/wezterm;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
