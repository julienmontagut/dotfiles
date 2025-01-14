# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, lib, config, pkgs, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "julien";
    homeDirectory =
      if isDarwin then
        "/Users/julien"
      else
        "/home/julien";
    sessionVariables = {
      # EDITOR = "nvim";
    };
  };

  xdg.enable = true;

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # programs.wezterm.enable = true;
  # programs.wezterm.enableZshIntegration = true;
  home.packages = with pkgs; [
    devenv
    gh
    gleam
    just
    lua
    neovim
    ollama
    timewarrior
  ];

  # fonts.fontConfig.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
  };
  programs.starship = {
    enable = true;
  };
  programs.eza = {
    enable = true;
    icons = "auto";
  };
  programs.bat = {
    enable = true;
    config.theme = "ansi";
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "base16_transparent";
      keys = {
        normal = {
          C-c = ":wqa!";
        };
        insert = {
         C-c = "normal_mode";
        };
      };
    };  
  };
  programs.fzf = {
    enable = true;
  };
  programs.fd = {
    enable = true;
  };
  programs.lazygit.enable = true;
  programs.ripgrep.enable = true;
  programs.yazi = {
    enable = true;
  };
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };
  # On nix-darwin `programs.firefox` is not available system-wide
  # TODO: On linux ensure firefox or librewolf is configured system-wide
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-unwrapped;
    profiles = {
      home = {
        settings = {
          "extensions.pocket.enabled" = false;
          # "browser.startup.homepage" = "https://nixos.org";
        };
      };
    };
  };
  # programs.firefox = {
  #   enable = true;
  #   package = null;
  #   profiles = {
  #     home = {
  #       isDefault = true;
  #       settings = {
  #         # "browser.startup.homepage" = "https://duckduckgo.com";
  #         "browser.search.defaultenginename" = "DuckDuckGo";
  #         "browser.search.order.1" = "DuckDuckGo";
  #         "extensions.autoDisableScopes" = 0;
  #       };
  #       search = {
  #         default = "DuckDuckGo";
  #         order = [ "DuckDuckGo" ];
  #       };
  #       extensions = with nur.repos.rycee.firefox-addons; [
  #         adguard-adblocker
  #         proton-pass
  #         icloud-passwords
  #       ];
  #     };
  #   };
  # };

  xdg.configFile = {
    "nvim".source = ./config/nvim;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
