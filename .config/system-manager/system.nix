{ lib, pkgs, ... }:
{
    imports = [
        ./kanata.nix
    ];

    config = {
        nixpkgs.hostPlatform = "x86_64-linux";

        environment.systemPackages = with pkgs; [
            home-manager
        ];
    };
}

