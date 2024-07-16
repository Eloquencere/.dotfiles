echo "Welcome to the installer, this will be part 1 of installing all necessary tools for development
This script will automatically reboot the system after it is done"
sleep 10

mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Temporary setup for zsh shell
sudo pacman -S --needed --noconfirm base-devel
sudo pacman -S --needed --noconfirm zsh neovim
chsh -s $(which zsh)
rm -f ~/.bash*
sudo pacman -Rs --noconfirm vim htop nano
echo "Do you have an amd or intel CPU?"
echo "a -> amd & i -> intel: "
read cpu_name
if [[ "$cpu_name" == "a" ]]; then
  sudo pacman -S --needed --noconfirm amd-ucode
elif [[ "$cpu_name" == "i" ]]; then
  sudo pacman -S --needed --noconfirm intel-ucode
fi

# System config
sudo sed -i "s/^\(GRUB_DEFAULT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT_STYLE=\).*/\1hidden/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo sed -i "s/^#\(Color\)/\1\nILoveCandy/g" /etc/pacman.conf
sudo sed -i "s/^#\(ParallelDownloads .*\)/\1/g" /etc/pacman.conf

# Language compilers and related packages
sudo pacman -S --needed --noconfirm perl go python
sudo pacman -S gdb valgrind strace ghidra # intentionaly not added --noconfirm
sudo pacman -S --needed --noconfirm clang lldb
# sudo pacman -S --noconfirm rustup
sudo pacman -S --noconfirm nodejs-lts-iron
# paru -S --noconfirm tailwindcss
sudo pacman -S --noconfirm python-pip pyenv tk

# Installing external package managers paru(AUR), flatpak(flathub)
sudo pacman -Syu --noconfirm
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru/
sudo pacman -S flatpak --noconfirm

# Basic software
sudo pacman -S --noconfirm arch-wiki-docs arch-wiki-lite
sudo pacman -S --noconfirm p7zip unrar tar exfat-utils ntfs-3g
sudo pacman -S --noconfirm libreoffice-fresh vlc
sudo pacman -S --noconfirm fastfetch btop # benchmarkers
sudo pacman -S --noconfirm stow speedtest-cli openbsd-netcat
sudo pacman -S --noconfirm ufw # firewall
sudo systemctl enable ufw --now
# Others
paru -S --noconfirm preload # to open up software faster
sudo systemctl enable preload --now
# paru -S auto-cpufreq
# sudo systemctl enable auto-cpufreq --now
paru -S --noconfirm tio pipes.sh

# Install fonts and extensions
sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd
flatpak install --assumeyes ExtensionManager

# Brave
paru -S --noconfirm brave-bin

# Command line tools
sudo pacman -S --noconfirm hub github-cli
sudo pacman -S --noconfirm fzf zoxide eza bat fd ripgrep jq less
sudo pacman -S --noconfirm yazi atuin gdu duf
sudo pacman -S --noconfirm man-db
paru -S --noconfirm tlrc-bin

# Terminal Emulator tools
sudo pacman -S --noconfirm alacritty starship tmux

echo "Do you want to install haskell?(Y/n)"
read usr_input
if [[ "$usr_input" == 'y' ]]; then
  sudo pacman -S ghc
  # curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh # Haskell
fi
# sudo pacman -S --noconfirm zig

# Onedriver
echo "Do you want to install onedriver?(Y/n)"
read usr_input
if [[ "$usr_input" == 'y' ]]; then
  mkdir $HOME/OneDrive
  paru -S --noconfirm onedriver
  rm -rf ~/Music ~/Pictures ~/Templates ~/Public
fi

# Remote machine tools
sudo pacman -S --noconfirm usbip
sudo sh -c "printf '%s\n%s\n' 'usbip-core' 'vhci-hcd' >> /etc/modules-load.d/usbip.conf"
echo "Do you want to install nomachine and rustdesk?(Y/n)"
read usr_input
if [[ "$usr_input" == 'y' ]]; then
  paru -S --noconfirm nomachine rustdesk-bin parsec-bin
fi

# Initialising all dot files
cd ~/.dotfiles
stow .
cd -

# Gnome Config
# Uninstall bloat
sudo pacman -Rs --noconfirm epiphany gnome-music gnome-calendar
sudo pacman -Rs --noconfirm gnome-contacts sushi gnome-weather
sudo pacman -Rs --noconfirm totem gnome-maps gnome-logs evince

# Bring minimise, maximise and close buttons to their positions
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font'

cd ~/Documents
rm -rf install_script_temp_folder

echo "The system will reboot now"

sleep 10
reboot
