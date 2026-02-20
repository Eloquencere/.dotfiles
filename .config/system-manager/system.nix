{ lib, pkgs, ... }:
let
    user = "eloquencer";
in
{
    config = {
        nixpkgs.hostPlatform = "x86_64-linux";
        # nix.settings.experimental-features = [ "nix-command" "flakes" ];

        environment.systemPackages = with pkgs; [
            home-manager
            kanata kmod
        ];

        users.groups.uinput = {}; # create uinput group
        users.users.${user} = {
            extraGroups = [ "input" "uinput" ];
        };

        services.udev.extraRules = ''
            # Kanata
            KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
        '';
        
        systemd.services.kanata = {
            description = "Kanata Keyboard remapper";
            wantedBy = [ "multi-user.target" ];

            serviceConfig = {
                Type = "simple";
                User = user;

                SupplementaryGroups = [ "input" "uinput" ];
                ExecStartPre = "${pkgs.kmod}/bin/modprobe uinput";
                ExecStart    = "${pkgs.kanata}/bin/kanata --cfg /home/${user}/.config/kanata/config.kbd";
            };
        };
    };
}

