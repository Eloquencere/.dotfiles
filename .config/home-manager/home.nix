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
        starship fzf atuin trash-cli

        lldb gdb valgrind strace
        scriptisto tio mise
        tlrc typst natural-docs doxygen

        neovim zellij wl-clipboard
        gh lazygit
        podman # Look into podman TUI

        croc fastfetch btop yazi
        stow git dos2unix
        ffmpeg fortune
        # WARN: Cautious with Ubuntu 26.04LTS
        zoxide eza fd bat ripgrep duf delta repgrep mprocs

        # # optional
        # carapace # needs to mature a lot
        # presenterm
        # graphviz # dependency for pydot
        # jq jqp yq cheat p7zip unrar
    ];
}

