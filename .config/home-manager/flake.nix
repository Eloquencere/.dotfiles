{
  description = "Home Manager configuration of eloquencer";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
        pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
    in
    {
      homeConfigurations."eloquencer" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
            ./home.nix
        ];
      };
    };
}

# install rustup via nix

