mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Bottles(Wine) Emulator
yes | flatpak install bottles

cd ~/Documents
rm -rf install_script_temp_folder
