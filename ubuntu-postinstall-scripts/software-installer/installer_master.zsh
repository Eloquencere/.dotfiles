#!/bin/zsh

cd "$(dirname "${(%):-%x}")" # change directory to script location

echo "Welcome to the *Ubuntu 26.04 LTS* installer :)"

# Installing nix pkg manager
sh <(curl --proto "=https" --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes

cd ~/.dotfiles
stow .
cd -

cd sub-scripts/
zsh -lc "source ./installer_slave.zsh"
cd -

echo "The system will reboot now to consolidate the installation"
read -r "?Press Enter to reboot..."
sudo reboot now

