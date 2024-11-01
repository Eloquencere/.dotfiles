sudo sh -c "nala update; nala upgrade -y"
sudo snap refresh
nix-env --upgrade
flatpak update --assumeyes
zinit update --all

