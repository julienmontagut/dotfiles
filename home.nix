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
      key-mapping.preset = "dvorak";

      gaps = {
        outer.top = [
          { monitor."Built-in" = 8; }
          40 
        ];
        outer.bottom = 8;
        outer.left = 8;
        outer.right = 8;
        inner.vertical = 8;
        inner.horizontal = 8;
      };

      # Integrate with sketchybar
      exec-on-workspace-change = [
        "${pkgs.bash}/bin/bash"
        "-c"
        "${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      # Hyper key bindings (Ctrl+Alt+Cmd+Shift)
      # Karabiner transforms left_command+key into cmd-ctrl-alt-shift+key
      mode.main.binding = {
        # Workspace switching
        "cmd-ctrl-alt-1" = "workspace 1";
        "cmd-ctrl-alt-2" = "workspace 2";
        "cmd-ctrl-alt-3" = "workspace 3";
        "cmd-ctrl-alt-4" = "workspace 4";

        # Move window to workspace and follow
        "cmd-ctrl-alt-shift-1" = ["move-node-to-workspace 1" "workspace 1"];
        "cmd-ctrl-alt-shift-2" = ["move-node-to-workspace 2" "workspace 2"];
        "cmd-ctrl-alt-shift-3" = ["move-node-to-workspace 3" "workspace 3"];
        "cmd-ctrl-alt-shift-4" = ["move-node-to-workspace 4" "workspace 4"];

        # Focus navigation
        "cmd-ctrl-alt-shift-h" = "focus left";
        "cmd-ctrl-alt-shift-j" = "focus down";
        "cmd-ctrl-alt-shift-k" = "focus up";
        "cmd-ctrl-alt-shift-l" = "focus right";

        # Layout control
        "cmd-ctrl-alt-shift-s" = "layout h_accordion";
        "cmd-ctrl-alt-shift-v" = "layout v_accordion";
        "cmd-ctrl-alt-shift-e" = "layout tiles";
        "cmd-ctrl-alt-shift-z" = "fullscreen";
        "cmd-ctrl-alt-shift-space" = "layout floating tiling";

        # Window management
        "cmd-ctrl-alt-shift-q" = "close";
        "cmd-ctrl-alt-shift-r" = "mode resize";

        # Applications
        "cmd-ctrl-alt-enter" = "exec-and-forget open -na Alacritty";
        "cmd-ctrl-alt-w" = "exec-and-forget open -na Firefox";
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
    ignores = [
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      ".CFUserTextEncoding"
      "Icon"
      "._*"
    ];
    settings = {
      # core.excludesfile = "${config.xdg.configHome}/git/ignore";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      submodule.recurse = true;
      user.email = "_@julienmontagut.com";
      user.name = "Julien Montagut";
      
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
      force = true;
    };
  };

  home.file = { ".local/bin".source = ./bin; };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
