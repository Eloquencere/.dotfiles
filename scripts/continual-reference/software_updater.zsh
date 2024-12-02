sudo sh -c "nala update; nala upgrade -y"
sudo snap refresh
nix-collect-garbage -d
flatpak update --assumeyes
zinit update --all

# nix-channel --update; nix-env --upgrade '*'
