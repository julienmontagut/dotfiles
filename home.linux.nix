{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "julien@upcast.co";
  home.homeDirectory = "/home/julien@upcast.co";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    devenv

    jq

    glab

    k9s
    kind
    kubectl
    kubectx
    # podman-compose

    jetbrains.rider
    jetbrains.webstorm

    vimb
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/julien.montagut@CDBDX.BIZ/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.preferXdgDirectories = true;

  # Enable generic Linux integration (automatically sources Nix profile)
  targets.genericLinux.enable = true;

  programs = {
    # ghostty.enable = true;
    git = {
      enable = true;
      settings = {
        pull.rebase = true;
        push.autoSetupRemote = true;
        submodule.recurse = true;
      };
      maintenance.enable = true;
    };
    zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
    };

    # Command line tooling
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    starship.enable = true;
    eza = {
      enable = true;
      icons = "auto";
    };
    bat = {
      enable = true;
      config.theme = "ansi";
    };
    fzf.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    zoxide = {
      enable = true;
      options = ["--cmd cd" ];
    };
    jujutsu.enable = true;
    neovim.enable = true;
    zellij.enable = true;
    claude-code.enable = true;
    # zed-editor.enable = true;
  };

  programs.fuzzel.enable = true;
  programs.waybar.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # services.podman.enable = true;

  xdg.enable = true;
}
