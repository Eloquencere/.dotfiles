sudo sh -c "nala full-upgrade -y" # apt-get dist-upgrade
sudo snap refresh
zinit update --all
flatpak update --assumeyes
nix profile upgrade --all; nix flake update
nix-collect-garbage --delete-old; nix store gc

echo "Update your nvim plugins & researt your machine"

# To update nix pkg manager
sudo $(which nix-env) --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon

# sudo auto-cpufreq --update

