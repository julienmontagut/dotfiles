{ config, pkgs, ... }:

{
  # Platform configuration
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Nix configuration
  nix.package = pkgs.lix;
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
      "firefox"
    ];
  };

  system.primaryUser = "julien";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
