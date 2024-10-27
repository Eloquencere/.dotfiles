{ pkgs ? import <nixpkgs> {} }:
with pkgs;
[
   fzf atuin zoxide mise 
   eza fd bat ripgrep curlie
   duf dust delta procs
   croc fastfetch
]
