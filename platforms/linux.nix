{ lib, config, pkgs, ... }:

let
  hmProfile = config.home.profileDirectory;
in
{
  targets.genericLinux.enable = lib.mkDefault true;

  # Linux-specific packages
  home.packages = with pkgs; [
    jetbrains.webstorm
  ];

  programs = {
    fuzzel.enable = true;
    waybar = {
      enable = true;
      systemd.enable = true; # Inherits target from wayland.systemd.target
    };
  };

  # Global wayland systemd target - all wayland services (waybar, etc.) bind to this
  wayland.systemd.target = "sway-session.target";

  # Use system sway (apt-installed) but configure it via ~/.config/sway/config
  # systemd.enable adds exec to import env vars and start sway-session.target
  wayland.windowManager.sway = {
    enable = true;
    package = null; # Use system sway, don't install from nixpkgs
    systemd.enable = true; # Enable systemd integration for sway-session.target
    config = {
      modifier = "Mod1";
      # Use home-manager managed alacritty
      terminal = "${hmProfile}/bin/alacritty";
      # Use home-manager managed fuzzel
      menu = "${hmProfile}/bin/fuzzel";

      gaps = {
        inner = 8;
        outer = 8;
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "dvorak";
          xkb_options = "ctrl:hyper_capscontrol";
        };

        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
        };

        "type:pointer" = {
          natural_scroll = "enabled";
        };
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

      # Disable default bar - we use waybar via home-manager
      bars = [ ];

      startup = [ ];
    };

    extraConfig = ''
      # Include system sway config.d for proper systemd integration
      include /etc/sway/config.d/*
    '';
  };
}
