sudo sh -c "nala full-upgrade -y"
sudo snap refresh

flatpak update --assumeyes
flatpak uninstall --unused --delete-data --assumeyes

nix profile upgrade --all; nix flake update
nix-collect-garbage --delete-old; nix store gc

zinit update --all

echo "Update your nvim plugins & researt your machine"

# # Update nix pkg manager
# sudo $(which nix-env) --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
# sudo systemctl daemon-reload
# sudo systemctl restart nix-daemon

# sudo auto-cpufreq --update

