mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Basic setup
sudo python ~/.dotfiles/.bin/conf_pacman.py

# Install fonts
sudo pacman -S ttf-jetbrains-mono-nerd

# Installing yay and git and curl
echo "Installing yay AUR package manager"
sudo pacman -Syu
sudo pacman -S base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay --version
echo "Done, cleaning up"
cd ..
rm -rf yay/
sudo pacman -S flatpak

# Uninstall bloat
sudo pacman -Rs epiphany # Remove browser
# gstreamer1.0-vaapi # video player
# and contacts, weather, tour


# Basic software
sudo pacman -S --needed arch-wiki-docs arch-wiki-lite
sudo pacman -S --needed p7zip unrar tar exfat-utils ntfs-3g
sudo pacman -S --needed libreoffice-fresh vlc
sudo pacman -S --needed fastfetch btop tree
sudo pacman -S --needed xclip stow usbip
# Others
# yay -S preload # to open up software faster
# sudo systemctl enable preload; sudo systemctl start preload
# Auto cpu-freq

# Command line tools
# fzf,  bat (& alias with cat), eza(& alias with ls), tlrc(alias with tldr), zoxide(alias with cd)

# Brave
echo "Installing Brave"
echo "Just keep pressing 'Enter' From here on" # Add a delay here
yay -S brave-bin
echo "Done"

# Alacritty Terminal Emulator
sudo pacman -S alacritty starship zellij

# Need to test these out
# gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/alacritty
# gsettings set org.gnome.desktop.default-applications.terminal exec-arg "--working-directory"

# Bottles(Wine) Emulator
flatpak install bottles

# Language compilers and related packages
# install pip for py n stuff

# Onedriver

# Seting up backup schemes (timeshift)
# betterfs for better backup & setup encrypted HDD

# Initialising all dot files
cd ~/.dotfiles
stow .
cd -
source ~/.zshrc


# Gnome Desktop Config
# Bring minimise, maximise and close buttons to their positions
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font' 

cd ~/Documents
rm -rf install_script_temp_folder

neofetch
echo "Reboot the system now"
