sudo sh -c "nala full-upgrade -y" # apt-get dist-upgrade
sudo snap refresh
zinit update --all
flatpak update --assumeyes
nix profile upgrade --all; nix flake update
nix-collect-garbage --delete-old; nix store gc

echo "Update your nvim plugins & researt your machine"

# sudo auto-cpufreq --update

