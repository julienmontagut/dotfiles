{
  description = "Julien's macOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }:
    let
      configuration = { pkgs, ... }: {

        nix.settings = {
          experimental-features = "nix-command flakes";
          trusted-users = [
            "root"
            "@admin"
            "@wheel"
          ];
        };

        nix.gc.automatic = true;
        nix.optimise.automatic = true;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Allow non-free packages
        # nixpkgs.config = {
        #   allowUnfree = true;
        #   allowUnfreePredicate = _: true;
        # };

        # Packages installed in system profile
        # environment.systemPackages = with pkgs; [
        #   lua
        #   luajit
        #   neovim
        # ];

        # Variables set in system profile
        environment.variables = {
          HOMEBREW_NO_ANALYTICS = "1";
          HOMEBREW_NO_ENV_HINTS = "1";
        };

        # Add ability to used TouchID for sudo authentication
        security.pam.enableSudoTouchIdAuth = true;

        # System configuration
        system = {

          defaults = {
            menuExtraClock.Show24Hour = true;

            # Trackpad defaults enabling tap to click, etc.
            trackpad = {
              Clicking = true;
              TrackpadRightClick = true;
              TrackpadThreeFingerDrag = true;
            };
          };

          keyboard = {
            enableKeyMapping = true;
            remapCapsLockToControl = true;
            nonUS.remapTilde = true;
          };

          # Set Git commit hash for darwin-version.
          configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          stateVersion = 5;
        };

        # Enable ZSH shell support in nix-darwin.
        # programs.zsh.enable = true;

        homebrew = {
          enable = true;
          onActivation = {
            autoUpdate = true;
            upgrade = true;
            cleanup = "zap";
          };

          casks = [
            "appcleaner"
            "anytype"
            "claude"
            "cursor"
            "element"
            "firefox"
            "font-inter"
            "font-lilex"
            "font-lilex-nerd-font"
            "font-literata"
            "inkscape"
            "proton-drive"
            "proton-mail"
            "proton-pass"
            "rider"
            "rustrover"
            "spotify"
            "steam"
            "utm"
            "wezterm"
            "whisky"
            "zed"
          ];

          masApps = {
            "Adguard for Safari" = 1440147259;
            "Proton Pass for Safari" = 6502835663;
            "TestFlight" = 899247664;
            "Xcode" = 497799835;
          };
        };

        users.users.julien = {
          name = "julien";
          home = "/Users/julien";
        };
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-de-Julien
      darwinConfigurations."MacBook-de-Julien" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration

          # home manager
          home-manager.darwinModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.julien = import ./home.nix;
          }
        ];
      };
    };
}
