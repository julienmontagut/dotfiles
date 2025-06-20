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
        normal = { bind = { "Ctrl c" = { SwitchToMode = "Locked"; }; }; };
        pane = { bind = { "Ctrl c" = { SwitchToMode = "Locked"; }; }; };
        tab = { bind = { "Ctrl c" = { SwitchToMode = "Locked"; }; }; };
        resize = { bind = { "Ctrl c" = { SwitchToMode = "Locked"; }; }; };
        move = { bind = { "Ctrl c" = { SwitchToMode = "Locked"; }; }; };
        search = { bind = { "Ctrl c" = { SwitchToMode = "Locked"; }; }; };
        session = { bind = { "Ctrl c" = { SwitchToMode = "Locked"; }; }; };
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
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
