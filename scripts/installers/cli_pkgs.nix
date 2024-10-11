{ pkgs ? import <nixpkgs> {} }:
with pkgs;
[
    stow
    p7zip
    dos2unix
	neovim
	fastfetch
	btop
	mise conan
	scriptisto
	gh
	fzf zoxide eza bat fd ripgrep
	yazi duf dust delta lazygit procs
	speedtest-rs jq yq jqp
	tlrc
	tio
	pipes
	atuin
	zellij
	docker lazydocker
	mprocs
	croc
	natural-docs doxygen
	curlie
	rar
]
