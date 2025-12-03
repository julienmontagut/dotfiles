{
  description = "julienmontagut's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations = {
      "julien@mac" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          username = "julien";
          homeDirectory = "/Users/julien";
          platform = "darwin";
        };
      };

      "julien@linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          username = "julien";
          homeDirectory = "/home/julien";
          platform = "linux";
        };
      };
    };
  };
}
