{
  description = "Home Manager configuration of eloquencer";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    hermes-agent.url = "github:NousResearch/hermes-agent";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, hermes-agent, ... }:
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
        extraSpecialArgs = { inherit hermes-agent; };
      };
    };
}

