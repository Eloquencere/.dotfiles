mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Bottles(Wine) Emulator
yes | flatpak install bottles

# Logisim evolution
yay -S logisim-evolution

cd ~/Documents
rm -rf install_script_temp_folder
