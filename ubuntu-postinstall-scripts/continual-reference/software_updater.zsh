#!/bin/zsh

sudo zsh -c "nala full-upgrade -y; nala autoremove; nala clean"
sudo snap refresh
app-manager --update-all

flatpak update --assumeyes
flatpak uninstall --unused --delete-data --assumeyes

nix profile upgrade --all
cd $XDG_CONFIG_HOME/home-manager
read -qt 10 "?Run 'nix flake update' (y/N)? " && nix flake update
home-manager switch --flake .
home-manager news &> /dev/null
nix-collect-garbage --delete-old
cd -

mise upgrade && mise cache clear && mise prune
pip cache purge
uv cache prune

zinit self-update
zinit update --all

hermes update
uv pip install --python $HERMES_HOME/hermes-agent/venv \
  -Ur $DOTFILES_HOME/ubuntu-postinstall-scripts/continual-reference/hermes_requirements.txt

rm -rf ~/.cache/*
sudo journalctl --vacuum-time=7d

echo "Update your nvim plugins & researt your machine"

# # Update nix pkg manager (Manually)
# sudo $(which nix-env) --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
# sudo systemctl daemon-reload
# sudo systemctl restart nix-daemon

# # Not installed
# sudo auto-cpufreq --update

