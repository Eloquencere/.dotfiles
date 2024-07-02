mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Bottles(Wine) Emulator
yes | flatpak install bottles

# Logisim evolution
yay -S logisim-evolution

# KiCAD
sudo pacman -Syu kicad
sudo pacman -Syu --asdeps kicad-library kicad-library-3d

cd ~/Documents
rm -rf install_script_temp_folder
