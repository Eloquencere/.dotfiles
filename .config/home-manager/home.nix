{ config, pkgs, lib, ... }:
{
    home.username = "eloquencer";
    home.homeDirectory = "/home/${config.home.username}";

    home.stateVersion = "25.11"; # Please check HM release notes before changing this number

    imports = [
        ./dconf.nix
    ];

    home.packages = with pkgs; [
        # Prompt improvement
        starship fzf atuin

        scriptisto
        gdb valgrind strace tio
        tlrc typst natural-docs doxygen

        neovim tree-sitter
        zellij wl-clipboard
        gh lazygit
        mise

        kilocode-cli github-copilot-cli

        zoxide eza yazi fd bat ripgrep repgrep duf delta trash-cli
        croc fastfetch btop hyperfine mprocs
        stow git dos2unix
        ffmpeg fortune

        # Rust crates
        bacon
        cargo-binstall
        cargo-expand # slightly outdated
        cargo-info
        cargo-deny # slightly outdated
        # # Profiling
        # cargo-bloat cargo-flamegraph

        # irust
        # cargo-generate # slightly outdated
        # cargo-nextest
        # cargo-dist
        # cargo-inspect # educational

        # # optional
        # carapace # needs to mature a lot
        # presenterm
        # graphviz # dependency for pydot
        # jq jqp yq cheat p7zip unrar
    ];
}

