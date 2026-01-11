# macOS-specific configuration
{ lib, config, pkgs, ... }:

{
  # macOS-specific packages
  home.packages = with pkgs; [
    # TODO: Install karabiner-elements using homebrew
  ];

  # Configuration for the macOS target
  targets.darwin = {
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

  # AeroSpace tiling window manager
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      enable-normalization-flatten-containers = true;
      key-mapping.preset = "dvorak";

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
        "cmd-ctrl-alt-shift-1" = [
          "move-node-to-workspace 1"
          "workspace 1"
        ];
        "cmd-ctrl-alt-shift-2" = [
          "move-node-to-workspace 2"
          "workspace 2"
        ];
        "cmd-ctrl-alt-shift-3" = [
          "move-node-to-workspace 3"
          "workspace 3"
        ];
        "cmd-ctrl-alt-shift-4" = [
          "move-node-to-workspace 4"
          "workspace 4"
        ];

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

  # Sketchybar status bar
  programs.sketchybar = {
    enable = false;
    config = {
      source = ../config/sketchybar;
      recursive = true;
    };
  };

  # JankyBorders window borders
  services.jankyborders = {
    enable = true;
    settings = {
      active_color = "0xff7aa2f7"; # Tokyo Night Storm Blue
      inactive_color = "0xff565f89"; # Tokyo Night Storm Gray
      width = 5.0;
      style = "round";
    };
  };

  # Karabiner configuration for keyboard remapping
  xdg.configFile."karabiner/karabiner.json" = {
    source = ../config/karabiner/karabiner.json;
    force = true;
  };

  # Alacritty terminal - macOS-specific window settings
  programs.alacritty.settings.window = {
    decorations = "buttonless";
    option_as_alt = "Both";
  };
}
