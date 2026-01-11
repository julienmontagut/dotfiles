{ config, pkgs, lib, ... }:
let
  # Get environment variables when running with --impure
  user = if builtins.getEnv "USER" != "" then builtins.getEnv "USER" else "julien";
  home = builtins.getEnv "HOME";
in
{
  # Read the release notes before changing
  home.stateVersion = "25.11";

  # Set the username and home directory
  home.username = lib.mkDefault user;
  home.homeDirectory = lib.mkDefault (
    if home != "" then home
    else if pkgs.stdenv.isDarwin then "/Users/${user}"
    else "/home/${user}"
  );

  home.packages = with pkgs; [
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
    nixfmt
    pulumi
    rustup
    timewarrior
    tree-sitter
    xh
    
    inter
    lilex
    nerd-fonts.lilex
  ];

  home.file = {
    ".local/bin".source = ./bin;
  };
  
  # Custom path
  home.sessionPath = [ 
    "$HOME/.local/bin" 
  ];

  # Custom environment variables
  home.sessionVariables = {
    # EDITOR = "vim";
  };

  xdg.enable = true;
  home.preferXdgDirectories = true;

  imports = [
    modules/neovim.nix
    modules/zsh.nix
  ];

  # Common program configurations
  programs.claude-code.enable = true;
  programs.lazygit.enable = true;
  programs.k9s.enable = true;
  programs.bacon.enable = true;
  # programs.delta.enable = true;
  # programs.zed-editor.enable = true;
  programs.git = {
    enable = true;
    # delta.enable = true;
    maintenance.enable = true;
    # TODO: Move this to a macos configuration
    ignores = [
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      ".CFUserTextEncoding"
      "Icon"
      "._*"
    ];
    includes = [
          {
            condition = "hasconfig:remote.*.url:ssh://tfs.cdbdx.biz:22/tfs/**";
            contents = {
              user.email = "julien.montagut@ext.cdiscount.com";
            };
          }
        ];
    settings = {
      # core.excludesfile = "${config.xdg.configHome}/git/ignore";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      submodule.recurse = true;
      user.email = lib.mkDefault "_@julienmontagut.com";
      user.name = "Julien Montagut";
    };
  };
  programs.firefox.enable = true;
  programs.alacritty = {
    enable = true;
    theme = "tokyo_night_storm";
    settings = {
      font.size = 16;
      font.normal = {
        family = "Lilex Nerd Font Mono";
        style = "Regular";
      };
      window = {
        opacity = 0.95;
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
      } // lib.optionalAttrs pkgs.stdenv.isDarwin {
        blur = true;
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
  # Let home manager manage itself
  programs.home-manager.enable = true;
}
