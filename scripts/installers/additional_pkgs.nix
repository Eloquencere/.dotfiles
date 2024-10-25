{ pkgs ? import <nixpkgs> {} }:
with pkgs;
[
    p7zip rar
    dos2unix
	btop
	conan
	gh
	yazi
	speedtest-rs jq yq jqp
	tlrc cheat
	tio
	pipes
	zellij
	mprocs
	neovim
	scriptisto
    lazygit
	docker lazydocker
    podman distrobox
	natural-docs doxygen
]
