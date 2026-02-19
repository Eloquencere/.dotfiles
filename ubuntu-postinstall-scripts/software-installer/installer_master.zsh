#!/bin/zsh

cd "$(dirname "${(%):-%x}")" # change directory to script location

echo "Welcome to the *Ubuntu 26.04 LTS* installer :)
This script is designed to install as much as possible without human intervention
It will automatically reboot the system after it is done"

# Installing nix pkg manager
sh <(curl --proto "=https" --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes

# to load ~/.config/nix to enable flakes
cd ~/.dotfiles
stow .
cd -

cd sub-scripts/
zsh -lc "source ./installer_slave.zsh"
cd -

echo "The system will reboot now to consolidate the installation"
read -r "?Press Enter to reboot..."
sudo reboot now

