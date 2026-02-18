{ config, pkgs, lib, ... }:
{
    home.username = "eloquencer";
    home.homeDirectory = "/home/${config.home.username}";

    home.stateVersion = "25.11"; # Please check HM release notes before changing this number

    # can implement this logic cleanly in system manager if I decide to go ahead with it
    # home.activation.nixGcOnSwitch =
    #  lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #    ${pkgs.nix}/bin/nix-collect-garbage --delete-old || true
    #    ${pkgs.nix}/bin/nix store gc || true
    #  '';

    # NOTE: Do dotfile management with home manager

    home.packages = with pkgs; [
        # lanuage compilers
        rustup zig julia
        gdb valgrind strace
        clang lldb
        conan scriptisto tio sqlite-interactive mise
        tlrc typst natural-docs doxygen
        # Prompt improvement
        starship fzf atuin
        croc fastfetch btop yazi
        neovim zellij wl-clipboard
        gh lazygit
        podman # look into podmanTUI
        stow git curl
        # WARN: Cautious with Ubuntu 26.04LTS
        zoxide eza fd bat ripgrep duf delta repgrep mprocs

        # # if not shipped by Ubuntu (delete if so)
        # dos2unix curl p7zip unrar zstd gnuplot graphviz

        # optional
        # jq jqp yq ollama cheat
    ];

    imports = [
        ./dconf.nix
    ];

    programs.home-manager.enable = true;
}

