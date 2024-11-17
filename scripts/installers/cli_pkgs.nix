{ pkgs ? import <nixpkgs> {} }:
with pkgs;
[
   starship fzf atuin zoxide mise 
   eza fd bat ripgrep
   duf delta
   croc fastfetch

   p7zip rar
   dos2unix btop yazi
   speedtest-cli jq yq jqp
   neovim zellij mprocs
   conan scriptisto tio
   gh lazygit
   docker lazydocker
   podman distrobox
   tlrc cheat
   natural-docs doxygen
   pipes
]

