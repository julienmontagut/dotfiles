{ config, pkgs, ... }:

{
  # Import common and platform-specific modules
  imports = [
    # Common modules
    modules/neovim.nix
    modules/zsh.nix

    # Optional modules (uncomment as needed)
    # ./modules/browser.nix
    # ./modules/neovim.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    # You can add overlays here
    # overlays = [
    #   # If you want to use overlays exported from other flakes:
    #   # neovim-nightly-overlay.overlays.default
    #
    #   # Or define it inline, for example:
    #   # (final: prev: {
    #   #   hi = final.hello.overrideAttrs (oldAttrs: {
    #   #     patches = [ ./change-hello-to-hi.patch ];
    #   #   });
    #   # })
    # ];
  };

  home = {
    # inherit username homeDirectory;
    sessionPath = [ "$HOME/.local/bin" ];
    preferXdgDirectories = true;
  };

  # Enable XDG
  xdg.enable = true;

  # Common packages for all platforms
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

  # Common program configurations
  programs.claude-code.enable = true;
  # Enable home-manager
  programs.home-manager.enable = true;
  programs.lazygit.enable = true;
  programs.k9s.enable = true;
  programs.bacon.enable = true;
  # programs.delta.enable = true;
  # programs.zed-editor.enable = true;
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
      font.size = 18;
      font.normal = {
        family = "Lilex Nerd Font Mono";
        style = "Regular";
      };
      window = {
        opacity = 0.95;
        blur = true;
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
      };
      keyboard.bindings = [
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }
        {
          key = "V";
          mods = "Control|Shift";
          action = "Paste";
        }
      ];
    };
  };
  programs.jujutsu.enable = true;
  programs.go.enable = true;
  programs.zellij = {
    enable = true;
    settings = {
      attach_to_session = true;
      default_mode = "locked";
      session_name = "default";
      show_startup_tips = false;
      simplified_ui = true;
      theme = "ansi";
    };
  };

  home.file = {
    ".local/bin".source = ./bin;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
