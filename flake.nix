{
  description = "julienmontagut's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      nixos-wsl,
      home-manager,
      stylix,
      ...
    }:
    let
      mkHomeConfig =
        { system, modules }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [ stylix.homeModules.stylix ] ++ modules;
        };
    in
    {
      darwinConfigurations."Julien-Macbook" = nix-darwin.lib.darwinSystem {
        modules = [ ./hosts/macbook.nix ];
        # specialArgs = { inherit inputs; };
      };

      nixosConfigurations."NixOS-WSL" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.wsl
          ./hosts/nixos-wsl.nix
        ];
      };

      homeConfigurations = {
        "macos" = mkHomeConfig {
          system = "aarch64-darwin";
          modules = [
            ./home.nix
            ./platforms/macos.nix
          ];
        };

        "linux" = mkHomeConfig {
          system = "x86_64-linux";
          modules = [
            ./home.nix
            ./platforms/linux.nix
          ];
        };
      };
    };
}
