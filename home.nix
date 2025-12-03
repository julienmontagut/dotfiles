# home-manager configuration
{ inputs, lib, config, pkgs, username, homeDirectory, platform, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  # Import common and platform-specific modules
  imports = [
    # Common modules
    ./modules/zsh.nix

    # Optional modules (uncomment as needed)
    # ./modules/browser.nix
    # ./modules/neovim.nix
  ] ++ lib.optional (platform == "darwin") ./modules/darwin.nix
    ++ lib.optional (platform == "linux") ./modules/linux.nix;

  nixpkgs = {
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
    config.allowUnfree = true;
  };

  home = {
    inherit username homeDirectory;
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
        opacity = 0.95;
        blur = true;
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
        # Platform-specific settings (decorations, option_as_alt) are in platform modules
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
    # Platform-specific config files (karabiner) are in platform modules
  };

  home.file = { ".local/bin".source = ./bin; };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
