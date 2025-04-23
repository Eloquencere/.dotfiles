sudo sh -c "nala update; nala upgrade -y"
sudo snap refresh
zinit update --all
nix-channel --update; nix profile upgrade --all; nix-collect-garbage --delete-old; nix store gc

echo "Update your nvim plugins as well"

# Optional
# flatpak update --assumeyes
