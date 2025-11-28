{
  description = "Home Manager configuration";

  inputs = {
    # Increment release branch for NixOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      # Follow corresponding `release` branch from Home Manager
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations."somepc" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
          system = "x86_64-linux";
	  config = {
	    allowUnfree = true;
            # allowUnfreePredicate = pkg: true;
	  };
      };
      modules = [ ./home.nix ];
    };
  };
}
