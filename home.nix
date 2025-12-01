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
    config.allowUnfree = true;
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

    # Store applications directly under ~/Applications
    copyApps.directory = "Applications";

    # Set some sensible macOS defaults
    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        AppleMetricUnits = true;
      };
      "com.apple.dock" = {
        autohide = true;
        orientation = "left";
      };
      "com.apple.universalaccess" = {
        keyboardAccessEnabled = false;
      };
    };
  };

  # Enable XDG
  xdg.enable = true;

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

  programs.aerospace = {
    enable = isDarwin;
    launchd.enable = isDarwin;
    userSettings = {
      enable-normalization-flatten-containers = true;
      gaps = {
        outer.top = 8;
        outer.bottom = 8;
        outer.left = 8;
        outer.right = 8;
        inner.vertical = 8;
        inner.horizontal = 8;
      };
      mode.main.binding = {

        # alt-enter = "exec-and-forget alacritty";

        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # Workspace navigation
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";

        # Move windows to warkpsace
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";

        # Enter resize mode (explicitly define it so we control it)
        alt-r = "mode resize";
      };

      # Define resize mode with clear exit strategy
      mode.resize.binding = {
        # Use hjkl to resize windows
        h = "resize width -50";
        j = "resize height +50";
        k = "resize height -50";
        l = "resize width +50";

        # Exit resize mode with ESC or Enter
        esc = "mode main";
        enter = "mode main";
      };
    };
  };
  programs.sketchybar = {
    enable = isDarwin;
    config = ''
      sketchybar --bar height=32 \
                       color=0xff1a1b26 \
                       border_color=0xff292e42 \
                 --add item battery right \
                 --set battery update_freq=60 \
                             script="$HOME/.config/sketchybar/plugins/battery.sh" \
                             icon.font="$FONT:Bold:15.0" \
                             label.font="$FONT:Regular:15.0" \
                             icon.color=0xffaaffaa \
                             label.color=0xffaaffaa
                             '';
  };
  services.jankyborders.enable = isDarwin;

  # TODO: check the latest mynixos options and configure sketchybar properly
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
  programs.alacritty = {
    enable = true;
    theme = "tokyo_night_storm";
    settings = {
      font.size = 15;
      font.normal = {
        family = "Lilex Nerd Font Mono";
        style = "Regular";
      };
    };
  };
  programs.go.enable = true;
  programs.zellij.enable = true;

  # programs.gh.enable = true;
  programs.gh-dash.enable = true;

  # Add custom configuration files
  xdg.configFile = {
    "nvim" = {
      source = ./config/nvim;
      onChange = ''
        mkdir -p ${config.xdg.dataHome}/nvim
        cp -f ${config.xdg.configHome}/nvim/lazy-lock.json ${config.xdg.dataHome}/nvim/lazy-lock.json
      '';
    };
  };

  home.file = { ".local/bin".source = ./bin; };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
