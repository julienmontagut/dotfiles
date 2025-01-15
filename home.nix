# This is your home-manager configuration file

# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, lib, config, pkgs, ... }:

let inherit (pkgs.stdenv) isDarwin isLinux;
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    # inputs.nixvim.homeManagerModules.nixvim

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  # nixpkgs = {
  #   # You can add overlays here
  #   overlays = [
  #     # If you want to use overlays exported from other flakes:
  #     # neovim-nightly-overlay.overlays.default
  #
  #     # Or define it inline, for example:
  #     # (final: prev: {
  #     #   hi = final.hello.overrideAttrs (oldAttrs: {
  #     #     patches = [ ./change-hello-to-hi.patch ];
  #     #   });
  #     # })
  #   ];
  #   # Configure your nixpkgs instance
  #   config = {
  #     # Disable if you don't want unfree packages
  #     allowUnfree = true;
  #     # Workaround for https://github.com/nix-community/home-manager/issues/2942
  #     allowUnfreePredicate = _: true;
  #   };
  # };

  # TODO: Set your username
  home = {
    username = "julien";
    homeDirectory = if isDarwin then "/Users/julien" else "/home/julien";
    sessionVariables = { EDITOR = "nvim"; };
  };

  xdg.enable = true;

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # programs.wezterm.enable = true;
  # programs.wezterm.enableZshIntegration = true;
  home.packages = with pkgs; [
    devenv
    gh
    gleam
    just
    lua
    neovim
    ollama
    rustup
    timewarrior
  ];

  # fonts.fontConfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
  };
  programs.starship = { enable = true; };
  programs.eza = {
    enable = true;
    icons = "auto";
  };
  programs.bat = {
    enable = true;
    config.theme = "ansi";
  };
  programs.helix = {
    enable = false;
    settings = {
      theme = "base16_transparent";
      keys = { insert = { C-c = "normal_mode"; }; };
    };
  };
  programs.fzf = { enable = true; };
  programs.fd = { enable = true; };
  programs.lazygit.enable = true;
  programs.ripgrep.enable = true;
  programs.yazi = { enable = true; };
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };
  # On nix-darwin `programs.firefox` is not available system-wide
  # TODO: On linux ensure firefox or librewolf is configured system-wide
  programs.firefox = {
    enable = true;
    package = null;
    profiles = {
      home = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          # icloud-passwords
          proton-pass
          ublock-origin
        ];
        search = {
          default = "DuckDuckGo";
          order = [ "DuckDuckGo" ];
        };
        settings = {
          "browser.startup.page" = 3;
          "browser.startup.homepage" = "about:blank";
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.search.defaultenginename" = "DuckDuckGo";
          "browser.search.order.1" = "DuckDuckGo";
          "browser.translations.enable" = false;
          "browser.warnOnQuit" = false;
          "browser.warnOnQuitShortcut" = false;
          "extensions.autoDisableScopes" = 0;
          "extensions.getAddons.showPanes" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "extensions.pocket.enabled" = false;
        };
      };
      work = {
        id = 1;
        settings = {
          "extensions.pocket.enabled" = false;
          "browser.search.defaultenginename" = "DuckDuckGo";
          "browser.search.order.1" = "DuckDuckGo";
          "extensions.autoDisableScopes" = 0;
        };
      };
    };
  };

  # Add custom configuration files
  xdg.configFile = {
    "ghostty".source = ./config/ghostty;
    "nvim".source = ./config/nvim;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
