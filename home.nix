# home-manager configuration
{ inputs, lib, config, pkgs, ... }:

let inherit (pkgs.stdenv) isDarwin isLinux;
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # Configuration modules for programs
    # ./programs/browser.nix
    # ./programs/claude.nix
    # ./programs/neovim.nix
    ./programs/zsh.nix
  ];

  nixpkgs = {
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
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      # allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "julien";
    homeDirectory = if isDarwin then "/Users/julien" else "/home/julien";
    sessionPath = [ "$HOME/.local/bin" ];
    preferXdgDirectories = true;
  };

  # Configuration for the MacOS target
  targets.darwin = {
    # Add MacOS-specific configuration here
    # programs.macos-settings.enable = true;
    # TODO: Put back when available in release 25.11
    copyApps = {
      enable = true;
      directory = "Applications";
    };
    linkApps.enable = false;
    # linkApps = {
      # enable = false;
      # directory = "Applications";
    # };
    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        AppleMetricUnits = true;
      };
      "com.apple.dock" = {
        autohide = true;
        orientation = "left";
      };
    };
  };

  # Enable XDG
  xdg.enable = true;

  # Catppuccin theme configuration
  catppuccin = {
    enable = true;
    flavor = "macchiato";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    ansible
    bun
    devenv
    dua
    gh
    glab
    jetbrains.goland
    jetbrains.rider
    jetbrains.rust-rover
    just
    jq
    k9s
    kind
    kubectl
    kubectx
    lua
    mprocs
    nixfmt-rfc-style
    nodejs
    pulumi
    rustup
    talosctl
    timewarrior
    tree-sitter
    xh
  ];

  # Only supported on linux
  # fonts.fontConfig.enable = true;
  # services.podman.enable = true;

  programs.aerospace = {
    enable = isDarwin;
    userSettings = {
      gaps = {
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 8;
        outer.right = 8;
      };
      mode.main.binding = {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
      };
    };
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  programs.claude-code.enable = true;
  # Enable home-manager
  programs.home-manager.enable = true;
  programs.lazygit.enable = true;
  programs.k9s.enable = true;
  programs.bacon.enable = true;
  # programs.delta.enable = true;
  programs.ghostty = {
    enable = true;
    # package = isDarwin ? pkgs.ghostty-bin : ghostty;
    package = pkgs.ghostty-bin;
  };
  programs.git = {
    enable = true;
    # delta.enable = true;
    maintenance.enable = true;
    settings = {
      user.name = "Julien Montagut";
      user.email = "_@julienmontagut.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      submodule.recurse = true;
    };
  };
  programs.firefox.enable = true;
  programs.alacritty.enable = true;
  programs.go.enable = true;
  programs.zellij.enable = true;
  # services.podman.enable = true;

  # programs.gh.enable = true;
  programs.gh-dash.enable = true;

  # Add custom configuration files
  xdg.configFile = {
    # "ghostty".source = ./config/ghostty;
    # "nvim" = {
    #   source = ./config/nvim;
    #   onChange = ''
    #     mkdir -p ${config.xdg.dataHome}/nvim
    #     cp -f ${config.xdg.configHome}/nvim/lazy-lock.json ${config.xdg.dataHome}/nvim/lazy-lock.json
    #   '';
    # };
    # "nvim-alt" = {
    #   source = ./config/nvim;
    #   onChange = ''
    #     mkdir -p ${config.xdg.dataHome}/nvim-alt
    #     cp -f ${config.xdg.configHome}/nvim-alt/lazy-lock.json ${config.xdg.dataHome}/nvim-alt/lazy-lock.json
    #   '';
    # };
  };

  home.file = { ".local/bin".source = ./bin; };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
