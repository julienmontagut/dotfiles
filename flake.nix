{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    catppuccin.url = "github:catppuccin/nix/release-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, catppuccin, ... }: {
    homeConfigurations = {
      "julien" = home-manager.lib.homeManagerConfiguration {
        # System is very important!
        pkgs = import nixpkgs { system = "aarch64-darwin"; };
        modules = [ 
          ./home.nix
          catppuccin.homeModules.catppuccin
        ];
      };
    };
  };
}
