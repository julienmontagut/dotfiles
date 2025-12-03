# Linux-specific configuration
{ lib, config, pkgs, ... }:

let
  mod = "Mod1"; # Alt (physically same position as Cmd on macOS)
in
{
  # TODO: Check that we are not running in nixos
  targets.genericLinux.enable = true;

  # Enable font configuration for Linux
  fonts.fontConfig.enable = true;

  # Linux-specific packages
  home.packages = with pkgs; [
    # Add Linux-specific packages here
  ];

  programs = {
    fuzzel.enable = true;
    waybar.enable = true;
  }

  # Sway window manager for Wayland
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = mod;
      terminal = "alacritty";

      gaps = {
        inner = 8;
        outer = 8;
      };

      keybindings = lib.mkOptionDefault {
        # Workspace switching (matches macOS cmd+1/2/3/4)
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";

        # Move window to workspace (matches macOS cmd-shift+1/2/3/4)
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";

        # Focus navigation (matches macOS cmd-shift+h/j/k/l)
        "${mod}+Shift+h" = "focus left";
        "${mod}+Shift+j" = "focus down";
        "${mod}+Shift+k" = "focus up";
        "${mod}+Shift+l" = "focus right";

        # Layout manipulation (matches macOS cmd-shift+s/v/e/z)
        "${mod}+Shift+s" = "layout stacking"; # split/stack
        "${mod}+Shift+v" = "splitv"; # vertical split
        "${mod}+Shift+e" = "layout toggle split"; # toggle
        "${mod}+Shift+z" = "fullscreen toggle"; # zoom
        "${mod}+Shift+space" = "floating toggle"; # matches macOS cmd-shift+space

        # Window management (matches macOS cmd-shift+c)
        "${mod}+Shift+c" = "kill"; # close window

        # Application launching (matches macOS cmd+return)
        "${mod}+Return" = "exec alacritty"; # terminal

        # Resize mode (matches macOS cmd-shift+r)
        "${mod}+Shift+r" = "mode resize";
      };

      modes = {
        resize = {
          "h" = "resize shrink width 50 px";
          "j" = "resize grow height 50 px";
          "k" = "resize shrink height 50 px";
          "l" = "resize grow width 50 px";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };
    };
  };

  # Alacritty terminal - Linux-specific window settings
  programs.alacritty.settings.window = {
    decorations = "full";
  };
}
