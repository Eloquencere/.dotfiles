#!/bin/zsh
set -o errexit \
    -o nounset \
    -o pipefail

sudo nala full-upgrade -y
sudo snap refresh

flatpak update --assumeyes
flatpak uninstall --unused --delete-data --assumeyes

nix-channel --update
cd ~/.config/home-manager
nix profile upgrade --all; nix flake update
home-manager switch --flake .
home-manager news &> /dev/null
nix-collect-garbage --delete-old; nix store gc
cd -

mise upgrade

zinit self-update
zinit update --all

echo "Update your nvim plugins & researt your machine"

# # Update stirling pdf (Manually)
# cd ~/.config/stirling-pdf/
# docker compose pull stirling-pdf && docker compose up -d stirling-pdf
# cd -

# # Update nix pkg manager (Manually)
# sudo $(which nix-env) --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
# sudo systemctl daemon-reload
# sudo systemctl restart nix-daemon

# # Not installed
# sudo auto-cpufreq --update

