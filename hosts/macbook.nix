{ config, pkgs, ... }:

{
  # Platform configuration
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Nix configuration
  nix.package = pkgs.lix;
  nix.gc.automatic = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "julien"
    ];
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    neovim
  ];

  homebrew = {
    enable = true;

    casks = [
      # "aerospace"
      # "anytype"
      "appcleaner"
      # "bitwarden"
      "claude"
      # "element"
      "firefox"
      # "font-inter"
      # "font-lilex"
      # "font-lilex-nerd-font"
      # "font-literata"
      # "ghostty"
      # "google-chrome"
      # "google-drive"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keymapp"
      "lm-studio"
      # "motion"
      # "netbirdio/tap/netbird-ui"
      "orbstack"
      "spotify"
      "steam"
      # "utm"
      "wezterm"
      # "whatsapp"
      "zed"
      # tap "FelixKratz/formulae"
      # tap "netbirdio/tap"
      # tap "nikitabobko/tap"
    ];
  };

  system.primaryUser = "julien";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
