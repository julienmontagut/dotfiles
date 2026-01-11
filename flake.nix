{
  description = "julienmontagut's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
