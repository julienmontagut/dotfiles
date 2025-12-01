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

      # Integrate with sketchybar
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      mode.main.binding = {

        cmd-ctrl-t = "exec-and-forget alacritty";
        cmd-ctrl-w = "exec-and-forget firefox";

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
      # Tokyo Night Storm Color Palette
      BG=0xff24283b
      BLACK=0xff000000
      FG=0xffc0caf5
      BLUE=0xff7aa2f7
      CYAN=0xff7dcfff
      GREEN=0xff9ece6a
      YELLOW=0xffe0af68
      RED=0xfff7768e
      MAGENTA=0xffbb9af7
      GRAY=0xff565f89

      FONT="SF Pro"

      # Detect display characteristics
      # Check if we're on a high-DPI external display (Studio Display is 5120x2880 or similar)
      MAIN_DISPLAY_WIDTH=$(system_profiler SPDisplaysDataType | grep "Resolution" | head -1 | awk '{print $2}')

      # Detect if internal display has notch (MacBook Pro 14"/16" have notch, resolution width is 3024 or 3456)
      INTERNAL_WIDTH=$(system_profiler SPDisplaysDataType | grep -A 20 "Built-In" | grep "Resolution" | awk '{print $2}')

      # Set bar height based on display (bigger for high-DPI external displays)
      if [ "$MAIN_DISPLAY_WIDTH" -gt 4000 ]; then
        BAR_HEIGHT=40
      else
        BAR_HEIGHT=32
      fi

      # Set bar color (black for notch displays, Tokyo Night for others)
      if [ "$INTERNAL_WIDTH" = "3024" ] || [ "$INTERNAL_WIDTH" = "3456" ] || [ "$INTERNAL_WIDTH" = "3456" ]; then
        BAR_COLOR=$BLACK
      else
        BAR_COLOR=$BG
      fi

      # Bar settings
      sketchybar --bar height=$BAR_HEIGHT \
                       blur_radius=30 \
                       position=top \
                       padding_left=20 \
                       padding_right=20 \
                       color=$BAR_COLOR

      # Default settings
      sketchybar --default updates=when_shown \
                           icon.font="$FONT:Bold:14.0" \
                           icon.color=$FG \
                           icon.padding_left=8 \
                           icon.padding_right=8 \
                           label.font="$FONT:Semibold:13.0" \
                           label.color=$FG \
                           label.padding_left=8 \
                           label.padding_right=8 \
                           background.padding_left=4 \
                           background.padding_right=4 \
                           background.padding_top=10 \
                           background.drawing=off

      # Workspace indicators (always show 1-4)
      sketchybar --add event aerospace_workspace_change

      for sid in 1 2 3 4; do
        sketchybar --add item space.$sid left \
                   --subscribe space.$sid aerospace_workspace_change \
                   --set space.$sid \
                         label="$sid" \
                         label.color=$FG \
                         icon.drawing=off \
                         click_script="aerospace workspace $sid" \
                         script="$HOME/.config/sketchybar/plugins/aerospace.sh $sid"
      done

      # Front app
      sketchybar --add item front_app left \
                 --set front_app icon.drawing=off \
                              label.color=$FG \
                              background.color=$BLUE \
                              background.height=3 \
                              background.y_offset=-14 \
                              background.drawing=on \
                              script="$HOME/.config/sketchybar/plugins/front_app.sh" \
                 --subscribe front_app front_app_switched

      # Right side items (added right to left)

      # Date
      sketchybar --add item date right \
                 --set date update_freq=30 \
                            icon= \
                            icon.color=$MAGENTA \
                            background.color=$MAGENTA \
                            background.height=3 \
                            background.y_offset=-14 \
                            background.drawing=on \
                            script="$HOME/.config/sketchybar/plugins/date.sh"

      # Battery (right before date)
      sketchybar --add item battery right \
                 --set battery update_freq=60 \
                               icon.color=$YELLOW \
                               background.color=$YELLOW \
                               background.height=3 \
                               background.y_offset=-14 \
                               background.drawing=on \
                               script="$HOME/.config/sketchybar/plugins/battery.sh"

      # RAM
      sketchybar --add item ram right \
                 --set ram update_freq=5 \
                           icon=󰍛 \
                           icon.color=$GREEN \
                           background.color=$GREEN \
                           background.height=3 \
                           background.y_offset=-14 \
                           background.drawing=on \
                           script="$HOME/.config/sketchybar/plugins/ram.sh"

      # CPU
      sketchybar --add item cpu right \
                 --set cpu update_freq=5 \
                           icon=󰻠 \
                           icon.color=$CYAN \
                           background.color=$CYAN \
                           background.height=3 \
                           background.y_offset=-14 \
                           background.drawing=on \
                           script="$HOME/.config/sketchybar/plugins/cpu.sh"

      # WiFi
      sketchybar --add item wifi right \
                 --set wifi update_freq=10 \
                            icon=󰖩 \
                            icon.color=$BLUE \
                            background.color=$BLUE \
                            background.height=3 \
                            background.y_offset=-14 \
                            background.drawing=on \
                            click_script="open /System/Library/PreferencePanes/Network.prefPane" \
                            script="$HOME/.config/sketchybar/plugins/wifi.sh"

      sketchybar --update
    '';
  };
  services.jankyborders = {
    enable = isDarwin;
    settings = {
      active_color = "0xff7aa2f7"; # Tokyo Night Storm Blue
      inactive_color = "0xff565f89"; # Tokyo Night Storm Gray
      width = 5.0;
      style = "round";
      # ax_focus = "on"; # Use accessibility API for better window detection
    };
  };

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
      window = {
        decorations = "buttonless"; # Remove title bar but keep rounded corners
        opacity = 0.95; # Slight transparency for modern look
        blur = true; # Enable background blur on macOS
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
        option_as_alt = "Both"; # macOS specific - use Option as Alt
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
    "sketchybar/plugins" = {
      source = ./config/sketchybar/plugins;
      recursive = true;
    };
  };

  home.file = { ".local/bin".source = ./bin; };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
