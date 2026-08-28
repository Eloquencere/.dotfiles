#!/bin/zsh

cd "$(dirname "${(%):-%x}")" # change directory to script location

sudo sh -c "nala full-upgrade -y; nala autoremove; nala clean"
sudo snap refresh
app-manager --update-all
flatpak update --assumeyes; flatpak uninstall --unused --delete-data --assumeyes

nix profile upgrade --all
cd $XDG_CONFIG_HOME/home-manager
read -qt 10 "?Run 'nix flake update' (y/N)? " && nix flake update
home-manager switch --flake .
home-manager news &> /dev/null
nix-collect-garbage --delete-old
cd -

mise upgrade && mise cache clear && mise prune -y
pip install --upgrade pip && pip cache purge

zinit self-update
zinit update --all

hermes update
uv pip install --python $HOME/.hermes/hermes-agent/venv \
  -r $DOTFILES_HOME/ubuntu-postinstall-scripts/continual-reference/hermes_requirements.txt
agy update

sudo journalctl --vacuum-time=7d

echo "Update your nvim plugins & restart your machine"

# # Vocalinux (official installer; rebuilds whisper.cpp with Vulkan for GPU)
# curl -fsSL https://raw.githubusercontent.com/VocaHQ/vocalinux/main/install.sh \
#   -o /tmp/vocalinux-update.sh && \
# bash /tmp/vocalinux-update.sh --auto
# rm -f /tmp/vocalinux-update.sh

# # Update nix pkg manager (Manually)
# sudo $(which nix-env) --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
# sudo systemctl daemon-reload
# sudo systemctl restart nix-daemon

# # Run manually
# uv cache prune
# npm update -g

# # Not installed
# sudo auto-cpufreq --update

