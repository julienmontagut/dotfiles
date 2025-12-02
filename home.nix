# hom-manager configuration
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
    ./modules/zsh.nix
    # ./programs/sway.nix
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
    # TODO: Install this only on macOS when available
    karabiner-elements
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
        outer.top = 12;
        outer.bottom = 8;
        outer.left = 8;
        outer.right = 8;
        inner.vertical = 8;
        inner.horizontal = 8;
      };

      # Integrate with sketchybar
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      mode.main.binding = {
        # Workspace switching (alt alone - simple!)
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";

        # Move windows to workspace (alt-shift = stronger action)
        alt-shift-1 = [ "move-node-to-workspace 1" "workspace 1" ];
        alt-shift-2 = [ "move-node-to-workspace 2" "workspace 2" ];
        alt-shift-3 = [ "move-node-to-workspace 3" "workspace 3" ];
        alt-shift-4 = [ "move-node-to-workspace 4" "workspace 4" ];

        # Focus navigation (alt-shift for consistency)
        alt-shift-h = "focus left";
        alt-shift-j = "focus down";
        alt-shift-k = "focus up";
        alt-shift-l = "focus right";

        # Layout manipulation (alt-shift for window manager control)
        alt-shift-s = "layout h_accordion"; # split/stack horizontal
        alt-shift-v = "layout v_accordion"; # vertical split
        alt-shift-e = "layout tiles"; # toggle layout
        alt-shift-z = "fullscreen"; # zoom/fullscreen
        alt-shift-space = "layout floating tiling"; # floating toggle

        # Window management
        alt-shift-c = "close"; # force close window

        # Application launching
        alt-enter = "exec-and-forget open -na Alacritty";
        alt-w = "exec-and-forget open -na Firefox";

        # Resize mode
        alt-shift-r = "mode resize";
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
    config = { 
      source = ./config/sketchybar;
      recursive = true;
    };
  };
  services.jankyborders = {
    enable = isDarwin;
    settings = {
      active_color = "0xff7aa2f7"; # Tokyo Night Storm Blue
      inactive_color = "0xff565f89"; # Tokyo Night Storm Gray
      width = 5.0;
      style = "round";
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
      window = {
        decorations = "buttonless"; 
        opacity = 0.95;
        blur = true;
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
        option_as_alt = "Both";
      };
      keyboard.bindings = [
        # Linux-style copy/paste (ctrl+shift+c/v)
        { key = "C"; mods = "Control|Shift"; action = "Copy"; }
        { key = "V"; mods = "Control|Shift"; action = "Paste"; }
      ];
    };
  };
  programs.go.enable = true;
  programs.zellij = {
    enable = true;
    settings = {
      attach_to_session = true;
      default_mode = "locked";
      simplified_ui = true;
      show_startup_tips = false;
      theme = "ansi";
    };
  };

  # Add custom configuration files
  xdg.configFile = {
    "nvim" = {
      source = ./config/nvim;
      onChange = ''
        mkdir -p ${config.xdg.dataHome}/nvim
        cp -f ${config.xdg.configHome}/nvim/lazy-lock.json ${config.xdg.dataHome}/nvim/lazy-lock.json
      '';
    };
    "karabiner/karabiner.json" = lib.mkIf isDarwin {
      source = ./config/karabiner/karabiner.json;
    };
  };

  home.file = { ".local/bin".source = ./bin; };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
