{ pkgs ? import <nixpkgs> {} }:
with pkgs;
[
   starship fzf atuin zoxide mise 
   eza fd bat ripgrep curlie
   duf dust delta procs
   croc fastfetch
]
