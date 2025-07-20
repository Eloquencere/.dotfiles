sudo sh -c "nala update; nala upgrade -y"
sudo snap refresh
zinit update --all
flatpak update --assumeyes
nix-channel --update; nix profile upgrade --all; nix-collect-garbage --delete-old; nix store gc

echo "Update your nvim plugins as well"

