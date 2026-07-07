{ config, pkgs, lib, ... }:
{
    home.username = "eloquencer";
    home.homeDirectory = "/home/${config.home.username}";

    home.stateVersion = "26.05"; # Please check HM release notes before changing this number

    imports = [
        ./dconf.nix
    ];

    home.packages = with pkgs; [
        scriptisto
        gdb valgrind strace tio
        navi tlrc
        typst doxygen natural-docs

        # Prompt improvement
        starship fzf atuin

        stow git dos2unix
        zoxide eza fd bat ripgrep duf delta
        yazi repgrep trash-cli
        croc fastfetch btop hyperfine mprocs
        ffmpeg fortune

        neovim tree-sitter
        zellij
        gh lazygit
        mise

        github-copilot-cli codex
        opencode
        opencommit

        # Rust crates
        sccache
        bacon
        cargo-binstall
        cargo-expand # slightly outdated
        cargo-info
        cargo-deny   # slightly outdated
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

