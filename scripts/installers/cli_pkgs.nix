{ pkgs ? import <nixpkgs> {} }:
with pkgs;
[
   starship fzf atuin zoxide mise 
   eza fd bat ripgrep
   duf delta
   croc fastfetch

   dos2unix btop yazi
   jq jqp yq
   neovim zellij mprocs
   conan scriptisto tio
   gh lazygit
   podman # look into podman TUI
   tlrc cheat
   natural-docs doxygen
]

