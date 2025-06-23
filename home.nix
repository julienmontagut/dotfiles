# This is your home-manager configuration file

# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, lib, config, pkgs, ... }:

let inherit (pkgs.stdenv) isDarwin isLinux;
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # Configuration modules for programs
    # ./programs/browser.nix
    ./programs/claude.nix
    ./programs/neovim.nix
    ./programs/zsh.nix
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

  home = {
    username = "julien";
    homeDirectory = if isDarwin then "/Users/julien" else "/home/julien";
    sessionVariables = { };
    preferXdgDirectories = true;
  };

  # Enable XDG
  xdg.enable = true;

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    bun
    devenv
    gh
    just
    kubectl
    kubectx
    lua
    nixfmt
    pulumi
    rustup
    timewarrior
    tree-sitter
    nodejs
  ];

  # fonts.fontConfig.enable = true;

  # Enable home-manager
  programs.home-manager.enable = true;
  programs.lazygit.enable = true;
  programs.k9s.enable = true;
  programs.zellij = {
    enable = true;
    settings = {
      default_mode = "locked";
      mouse_mode = false;
      hide_session_name = true;
      keybinds = {
        locked = { "bind \"Ctrl g\"" = { SwitchToMode = "Normal"; }; };
        normal = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
          "bind \"Ctrl p\"" = { SwitchToMode = "Pane"; };
          "bind \"Ctrl t\"" = { SwitchToMode = "Tab"; };
          "bind \"Ctrl r\"" = { SwitchToMode = "Resize"; };
          "bind \"Ctrl s\"" = { SwitchToMode = "Scroll"; };
          "bind \"Ctrl o\"" = { SwitchToMode = "Session"; };
          "bind \"Ctrl h\"" = { SwitchToMode = "Move"; };
          "bind \"Ctrl q\"" = "Quit";
        };
        pane = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
          "bind \"Ctrl p\"" = { SwitchToMode = "Normal"; };
          "bind \"h\" \"Left\"" = { MoveFocus = "Left"; };
          "bind \"l\" \"Right\"" = { MoveFocus = "Right"; };
          "bind \"j\" \"Down\"" = { MoveFocus = "Down"; };
          "bind \"k\" \"Up\"" = { MoveFocus = "Up"; };
          "bind \"p\"" = "SwitchFocus";
          "bind \"n\"" = [ "NewPane" { SwitchToMode = "Normal"; } ];
          "bind \"d\"" = [ { NewPane = "Down"; } { SwitchToMode = "Normal"; } ];
          "bind \"r\"" =
            [ { NewPane = "Right"; } { SwitchToMode = "Normal"; } ];
          "bind \"x\"" = [ "CloseFocus" { SwitchToMode = "Normal"; } ];
          "bind \"f\"" =
            [ "ToggleFocusFullscreen" { SwitchToMode = "Normal"; } ];
          "bind \"z\"" = [ "TogglePaneFrames" { SwitchToMode = "Normal"; } ];
          "bind \"w\"" = [ "ToggleFloatingPanes" { SwitchToMode = "Normal"; } ];
          "bind \"e\"" =
            [ "TogglePaneEmbedOrFloating" { SwitchToMode = "Normal"; } ];
        };
        tab = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
          "bind \"Ctrl t\"" = { SwitchToMode = "Normal"; };
          "bind \"h\" \"Left\" \"Up\" \"k\"" = "GoToPreviousTab";
          "bind \"l\" \"Right\" \"Down\" \"j\"" = "GoToNextTab";
          "bind \"n\"" = [ "NewTab" { SwitchToMode = "Normal"; } ];
          "bind \"x\"" = [ "CloseTab" { SwitchToMode = "Normal"; } ];
          "bind \"s\"" = [ "ToggleActiveSyncTab" { SwitchToMode = "Normal"; } ];
          "bind \"1\"" = [ { GoToTab = 1; } { SwitchToMode = "Normal"; } ];
          "bind \"2\"" = [ { GoToTab = 2; } { SwitchToMode = "Normal"; } ];
          "bind \"3\"" = [ { GoToTab = 3; } { SwitchToMode = "Normal"; } ];
          "bind \"4\"" = [ { GoToTab = 4; } { SwitchToMode = "Normal"; } ];
          "bind \"5\"" = [ { GoToTab = 5; } { SwitchToMode = "Normal"; } ];
          "bind \"Tab\"" = "ToggleTab";
        };
        resize = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
          "bind \"Ctrl r\"" = { SwitchToMode = "Normal"; };
          "bind \"h\" \"Left\"" = { Resize = "Increase Left"; };
          "bind \"j\" \"Down\"" = { Resize = "Increase Down"; };
          "bind \"k\" \"Up\"" = { Resize = "Increase Up"; };
          "bind \"l\" \"Right\"" = { Resize = "Increase Right"; };
          "bind \"H\"" = { Resize = "Decrease Left"; };
          "bind \"J\"" = { Resize = "Decrease Down"; };
          "bind \"K\"" = { Resize = "Decrease Up"; };
          "bind \"L\"" = { Resize = "Decrease Right"; };
          "bind \"=\" \"+\"" = { Resize = "Increase"; };
          "bind \"-\"" = { Resize = "Decrease"; };
        };
        scroll = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
          "bind \"Ctrl s\"" = { SwitchToMode = "Normal"; };
          "bind \"Ctrl c\"" = [ "ScrollToBottom" { SwitchToMode = "Normal"; } ];
          "bind \"j\" \"Down\"" = "ScrollDown";
          "bind \"k\" \"Up\"" = "ScrollUp";
          "bind \"Ctrl f\" \"PageDown\" \"Right\" \"l\"" = "PageScrollDown";
          "bind \"Ctrl b\" \"PageUp\" \"Left\" \"h\"" = "PageScrollUp";
          "bind \"d\"" = "HalfPageScrollDown";
          "bind \"u\"" = "HalfPageScrollUp";
        };
        session = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
          "bind \"Ctrl o\"" = { SwitchToMode = "Normal"; };
          "bind \"d\"" = "Detach";
        };
      };
    };
  };
  # services.podman.enable = true;

  programs.helix = {
    enable = true;
    package = pkgs.evil-helix;
  };

  # programs.gh.enable = true;
  programs.gh-dash.enable = true;

  # Add custom configuration files
  xdg.configFile = {
    "ghostty".source = ./config/ghostty;
    "nvim" = {
      source = ./config/nvim;
      onChange = ''
        mkdir -p ${config.xdg.dataHome}/nvim
        cp -f ${config.xdg.configHome}/nvim/lazy-lock.json ${config.xdg.dataHome}/nvim/lazy-lock.json
      '';
    };
    "nvim-alt" = {
      source = ./config/nvim;
      onChange = ''
        mkdir -p ${config.xdg.dataHome}/nvim-alt
        cp -f ${config.xdg.configHome}/nvim-alt/lazy-lock.json ${config.xdg.dataHome}/nvim-alt/lazy-lock.json
      '';
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
