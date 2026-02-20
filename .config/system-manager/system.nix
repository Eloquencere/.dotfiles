{ lib, pkgs, ... }:
{
    imports = [
        ./kanta.nix
    ];

    config = {
        nixpkgs.hostPlatform = "x86_64-linux";

        environment.systemPackages = with pkgs; [
            home-manager
        ];
    };
}

