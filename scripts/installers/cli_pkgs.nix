{ pkgs ? import <nixpkgs> {} }:
with pkgs;
[
   starship fzf atuin zoxide mise 
   eza fd bat ripgrep curlie
   duf dust delta procs
   croc fastfetch

   neovim
   p7zip rar dos2unix
   btop yazi
   conan scriptisto
   speedtest-cli jq yq jqp
   tlrc cheat
   tio
   zellij mprocs
   lazygit gh
   docker lazydocker
   podman distrobox
   natural-docs doxygen
   pipes
]

