{ config, pkgs, lib, ... }:
{
    home.username = "eloquencer";
    home.homeDirectory = "/home/${config.home.username}";

    home.stateVersion = "25.11"; # Please check HM release notes before changing this number

    imports = [
        ./dconf.nix
    ];

    home.packages = with pkgs; [
        # lanuage compilers
        rustup zig julia
        gdb valgrind strace
        conan scriptisto tio sqlite-interactive mise
        tlrc typst natural-docs doxygen
        just # better alternative to make(file)
        mask # CLI task runner from markdown file
        # Prompt improvement
        starship fzf atuin trash-cli
        croc fastfetch btop yazi
        neovim zellij wl-clipboard
        gh lazygit
        podman # look into podmanTUI
        stow git curl dos2unix
        # WARN: Cautious with Ubuntu 26.04LTS
        zoxide eza fd bat ripgrep duf delta repgrep mprocs
        fortune

        # optional
        # carapace # needs to mature a lot
        # presenterm
        # graphviz # dependency for pydot
        # jq jqp yq cheat p7zip unrar
    ];

    # programs.home-manager.enable = true; # NOTE: only enable this when using system manager
}

