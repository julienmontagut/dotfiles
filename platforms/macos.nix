# macOS-specific configuration
{
  lib,
  config,
  pkgs,
  ...
}:

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

  programs.firefox.package = lib.mkForce null;
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

      mode.main.binding = {
        # Workspace switching
        "cmd-ctrl-alt-1" = "workspace 1";
        "cmd-ctrl-alt-2" = "workspace 2";
        "cmd-ctrl-alt-3" = "workspace 3";
        "cmd-ctrl-alt-4" = "workspace 4";
        "cmd-ctrl-alt-5" = "workspace 5";

        # Move window to workspace and follow
        "cmd-ctrl-alt-shift-1" = "move-node-to-workspace 1";
        "cmd-ctrl-alt-shift-2" = "move-node-to-workspace 2";
        "cmd-ctrl-alt-shift-3" = "move-node-to-workspace 3";
        "cmd-ctrl-alt-shift-4" = "move-node-to-workspace 4";
        "cmd-ctrl-alt-shift-5" = "move-node-to-workspace 5";

        # Focus navigation
        "cmd-ctrl-alt-h" = "focus left";
        "cmd-ctrl-alt-j" = "focus down";
        "cmd-ctrl-alt-k" = "focus up";
        "cmd-ctrl-alt-l" = "focus right";

        # Layout control
        "cmd-ctrl-alt-shift-a" = "layout h_accordion";
        "cmd-ctrl-alt-shift-o" = "layout tiles";
        "cmd-ctrl-alt-shift-u" = "layout floating tiling";

        # Window management
        "cmd-ctrl-alt-q" = "close";
        "cmd-ctrl-alt-shift-m" = "mode layout";

        # Applications
        "cmd-ctrl-alt-enter" = "exec-and-forget open -na WezTerm";
        "cmd-ctrl-alt-shift-f" = "exec-and-forget open -a Firefox";
      };

      # Define resize mode with clear exit strategy
      mode.layout.binding = {

        # Move window to workspace and follow
        "1" = [
          "move-node-to-workspace 1"
          "workspace 1"
        ];
        "2" = [
          "move-node-to-workspace 2"
          "workspace 2"
        ];
        "3" = [
          "move-node-to-workspace 3"
          "workspace 3"
        ];
        "4" = [
          "move-node-to-workspace 4"
          "workspace 4"
        ];
        "5" = [
          "move-node-to-workspace 5"
          "workspace 5"
        ];

        # Use hjkl to resize windows
        "shift-h" = "resize width -50";
        "shift-j" = "resize height +50";
        "shift-k" = "resize height -50";
        "shift-l" = "resize width +50";

        # Exit resize mode with ESC or Enter
        esc = "mode main";
        "cmd-ctrl-alt-c" = "mode main";
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

}
