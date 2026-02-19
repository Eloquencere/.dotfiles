sudo sh -c "apt full-upgrade" # apt-get dist-upgrade
sudo snap refresh
zinit update --all
flatpak update
nix-channel --update; nix profile upgrade --all;
nix-collect-garbage --delete-old; nix store gc

echo "Update your nvim plugins & researt your machine"

# sudo auto-cpufreq --update

