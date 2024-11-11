{ pkgs ? import <nixpkgs> {} }:
with pkgs;
[
	neovim
    p7zip rar dos2unix
	btop yazi
	conan scriptisto
	speedtest-rs jq yq jqp
	tlrc cheat
	tio
	zellij mprocs
    lazygit gh
	docker lazydocker
    podman distrobox
	natural-docs doxygen
	pipes
]
