sudo sh -c "nala update; nala upgrade -y"
sudo snap refresh
nix-collect-garbage -d; nix-channel --update; nix-env --upgrade '*'
flatpak update --assumeyes
zinit update --all

