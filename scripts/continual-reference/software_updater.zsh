sudo sh -c "nala full-upgrade -y"
sudo snap refresh
zinit update --all
flatpak update --assumeyes
nix-channel --update; nix profile upgrade --all; nix-collect-garbage --delete-old; nix store gc
sudo auto-cpufreq --update

echo "Update your nvim plugins as well"

