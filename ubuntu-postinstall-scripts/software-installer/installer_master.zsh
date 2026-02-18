#!/bin/zsh

cd "$(dirname "${(%):-%x}")" # change directory to script location

echo "Welcome to the *Ubuntu 26.04 LTS* installer :)
This script is designed to install as much as possible without human intervention
It will automatically reboot the system after it is done"

# this is mainly to load ~/.config/nix to enable flakes & to load ~/.config/system-manager (if that happens to be the case)
# NOTE: Add system-manager to dotfiles, not sure if stow will work
cd ~/.dotfiles
stow .
cd -

# Installing nix pkg manager
sh <(curl --proto "=https" --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes

zsh -lc "source ./installer_slave.zsh" # not sure if sourcing is good
# or do - source /etc/profile.d/nix.sh

echo "The system will reboot now to consolidate the installation"
read -r "?Press Enter to reboot..."
sudo reboot now

