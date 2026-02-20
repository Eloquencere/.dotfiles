{ lib, pkgs, ... }:
let
    user = "eloquencer";
in
{
    config = {
        environment.systemPackages = with pkgs; [
            kanata kmod
        ];

        users.groups.uinput = {}; # create uinput group
        users.users.${user} = { # don't uncomment
        	isNormalUser = true;
            extraGroups = [ "input" "uinput" "networkmanager" "wheel" "sudo" ];
        };

        environment.etc."udev/rules.d/99-kanata.rules".text = ''
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

