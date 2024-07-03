mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Bottles(Wine) Emulator
yes | flatpak install bottles

# install overleaf
yay -S yacreader
sudo pacman -S obsidian zathura

cd ~/Documents
rm -rf install_script_temp_folder
