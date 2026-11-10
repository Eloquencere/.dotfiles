{ config, pkgs, lib, unstable, username, ... }:
{
    home.username = username;
    home.homeDirectory = "/home/${username}";
    home.stateVersion = "26.05"; # Please check HM release notes before changing this number

    news.display = "silent";

    imports = [
        ./dconf.nix
    ];

    home.packages = with pkgs; [
        kanata
        nerd-fonts.ubuntu-sans
        xdotool
        starship unstable.atuin zoxide

        zoxide eza fd bat ripgrep duf delta
        yazi fzf
        croc mprocs
        rclone

        unstable.neovim tree-sitter
        gh unstable.lazygit

        # Documentation
        tlrc cheat
        doxygen natural-docs
        hledger


        # # optional
        # lazydocker
        # jq jqp yq
        # scriptisto hyperfine
        # presenterm
        # carapace # needs to mature a lot
        # pandoc
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

