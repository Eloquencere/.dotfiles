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

    imports = [
        ./dconf.nix
    ];

    home.packages = with pkgs; [
        # lanuage compilers
        rustup zig julia
        gdb valgrind strace
        conan scriptisto tio sqlite-interactive mise
        tlrc typst natural-docs doxygen
        # Prompt improvement
        starship fzf atuin carapace trash-cli
        croc fastfetch btop yazi
        neovim zellij wl-clipboard
        gh lazygit
        podman # look into podmanTUI
        stow git curl dos2unix
        # WARN: Cautious with Ubuntu 26.04LTS
        zoxide eza fd bat ripgrep duf delta repgrep mprocs
        graphviz # dependency for pydot
        gnuplot # dependency for qalculate

        # optional
        # jq jqp yq ollama cheat p7zip unrar
    ];

    # programs.home-manager.enable = true; # NOTE: only enable this when using system manager
}

