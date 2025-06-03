{
  description = "Julien's macOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, nur }:
    let
      configuration = { pkgs, ... }: {

        nix.settings = {
          experimental-features = "nix-command flakes";
          trusted-users = [ "root" "@admin" "@wheel" ];
        };

        nix.gc.automatic = true;
        nix.optimise.automatic = true;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Allow non-free packages
        nixpkgs.config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };

        nixpkgs.overlays = [ nur.overlays.default ];

        # Packages installed in system profile
        environment.systemPackages = with pkgs; [
          lua
          luajit
          podman
          netbird
          # netbird

          # Packages to install on macos
          defaultbrowser
        ];

        # Variables set in system profile
        environment.variables = {
          HOMEBREW_NO_ANALYTICS = "1";
          HOMEBREW_NO_ENV_HINTS = "1";
        };

        # Add ability to used TouchID for sudo authentication
        security.pam.services.sudo_local.touchIdAuth = true;

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
            # nonUS.remapTilde = true;
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
            "claude"
            "element"
            "font-inter"
            "font-lilex"
            "font-lilex-nerd-font"
            "font-literata"
            "ghostty"
            "google-chrome"
            "google-drive"
            "jetbrains-toolbox"
            "obsidian"
            "orbstack"
            "raycast"
            "spotify"
            "steam"
            "todoist"
            "visual-studio-code"
            "whatsapp"
            "whisky"
            "zed"
          ];
        };

        users.users.julien = {
          name = "julien";
          home = "/Users/julien";
        };
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-de-Julien
      darwinConfigurations."MacBook-de-Julien" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration

          #home manager
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs nur; };
            home-manager.backupFileExtension = "previous";
            home-manager.users.julien = import ./home.nix;
          }
        ];
      };
    };
}
