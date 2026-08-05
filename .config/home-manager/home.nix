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
        xdotool
        nerd-fonts.ubuntu-sans

        valgrind strace
        tio

        # Prompt improvement
        starship fzf atuin

        stow
        zoxide eza fd bat ripgrep duf delta
        yazi repgrep trash-cli
        croc btop mprocs
        pandoc
        fortune

        # Documentation
        tlrc cheat
        typst doxygen natural-docs
        mask just
        hledger

        neovim tree-sitter
        zellij
        gh lazygit

        github-copilot-cli
        opencode

        # # optional
        # lazydocker
        # jq jqp yq
        # scriptisto hyperfine
        # presenterm
        # carapace # needs to mature a lot
    ];

    # Nerd Fonts for terminal icons (Starship, etc.)
    fonts.fontconfig.enable = true;

    # Move this to installer script
    systemd.user.services.kanata = {
        Unit = {
            Description = "Kanata keyboard remapper";
        };
        Service = {
            Type = "simple";
            ExecStart = "${pkgs.kanata}/bin/kanata --cfg %h/.config/kanata/config.kbd";
            Restart = "on-failure";
            RestartSec = "2s";
        };
        Install = {
            WantedBy = [ "default.target" ];
        };
    };
}

