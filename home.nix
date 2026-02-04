{
  config,
  pkgs,
  lib,
  ...
}:
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
    if home != "" then
      home
    else if pkgs.stdenv.isDarwin then
      "/Users/${user}"
    else
      "/home/${user}"
  );

  home.packages = with pkgs; [
    devenv
    dua
    gh
    glab
    glow
    just
    jq
    k9s
    kind
    keymapp
    kubectl
    kubectx
    lua
    mprocs
    nixfmt
    pulumi
    rustup
    slides
    timewarrior
    tree-sitter
    xh

    inter
    lilex
    nerd-fonts.lilex
  ];

  home.file = {
    # ".local/bin".source = ./bin;
  };

  xdg.configFile = {
    "ideavim/ideavimrc".source = ./config/ideavimrc;
  };

  # Custom path
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  xdg.enable = true;
  home.preferXdgDirectories = true;

  imports = [
    programs/firefox.nix
    programs/neovim.nix
    programs/zed.nix
    programs/zsh.nix
  ];

  # Common program configurations
  programs.claude-code.enable = true;
  programs.lazygit.enable = true;
  programs.k9s.enable = true;
  programs.bacon.enable = true;
  programs.delta.enable = true;
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
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      submodule.recurse = true;
      user.email = lib.mkDefault "_@julienmontagut.com";
      user.name = "Julien Montagut";
    };
  };
  # WezTerm config (installed via native package manager)
  xdg.configFile."wezterm/wezterm.lua".source = ./config/wezterm/wezterm.lua;
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

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  programs.starship.enable = true;

  programs.eza = {
    enable = true;
    icons = "auto";
  };
  programs.bat = {
    enable = true;
    config.theme = "ansi";
  };

  programs.fzf.enable = true;
  programs.fd.enable = true;
  programs.ripgrep.enable = true;
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  # Let home manager manage itself
  programs.home-manager.enable = true;
}
