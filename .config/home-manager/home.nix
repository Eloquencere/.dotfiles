{ config, pkgs, lib, ... }:
{
    home.username = "eloquencer";
    home.homeDirectory = "/home/${config.home.username}";

    home.stateVersion = "26.05"; # Please check HM release notes before changing this number

    imports = [
        ./dconf.nix
    ];

    home.packages = with pkgs; [
        kanata
        ydotool xdotool

        gdb valgrind strace
        tio

        # Prompt improvement
        starship fzf atuin

        stow git
        zoxide eza fd bat ripgrep duf delta
        yazi repgrep trash-cli
        croc fastfetch btop mprocs
        ffmpeg fortune

        # Documentation
        navi tlrc
        typst doxygen natural-docs

        neovim tree-sitter
        zellij
        gh lazygit
        mise # WARN: remove in 26.04

        github-copilot-cli
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
        # scriptisto hyperfine
    ];

    systemd.user.services.kanata = {
        Unit = {
            Description = "Kanata keyboard remapper";
        };
        Service = {
            Type = "simple";
            ExecStart = "${pkgs.kanata}/bin/kanata --cfg %h/.config/kanata/config.kbd";
            Restart = "on-failure";
        };
        Install = {
            WantedBy = [ "default.target" ];
        };
    };

    systemd.user.services.ydotoold = {
        Unit = {
            Description = "ydotool daemon - virtual input automation";
            Documentation = "https://github.com/ReimuNotMoe/ydotool";
        };
        Service = {
            ExecStart = "${pkgs.ydotool}/bin/ydotoold";
            Restart = "on-failure";
        };
        Install = {
            WantedBy = [ "default.target" ];
        };
    };

}

