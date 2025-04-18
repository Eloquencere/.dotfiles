sudo sh -c "nala update; nala upgrade -y"
sudo snap refresh
zinit update --all
nix-channel --update; nix profile upgrade --all

# Optional
flatpak update --assumeyes
