echo "Welcome to the installer, this will be part 1 of installing all necessary tools for development
This script will automatically reboot the system after it is done"
sleep 10

mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Temporary setup for zsh shell
BASIC_PKGS=(
  "base-devel" 
  "zsh" "neovim"
)
ARCH_BLOAT_PKGS=(
  "vim" "htop" "nano"
)
sudo pacman -S --needed --noconfirm "${BASIC_PKGS[@]}"
chsh -s $(which zsh)
rm -f ~/.bash*
sudo pacman -Rs --noconfirm "${ARCH_BLOAT_PKGS[@]}"
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
LANG_COMPILERS_PKGS=(
  "perl" "go" "python"
  "clang" "lldb"
  "rustup"
  "nodejs-lts-iron" 
  "pyenv" "python-pip" "tk"
  # "zig"
)
LANG_COMPILERS_PKGS_PARU=(
  # "tailwindcss"
  "scriptisto" # script in any compiled language
)
sudo pacman -S gdb valgrind strace ghidra
sudo pacman -S --needed --noconfirm "${LANG_COMPILERS_PKGS[@]}"
rustup toolchain install stable
rustup default stable

echo "Do you want to install haskell?(Y/n)"
read usr_input
if [[ "$usr_input" == 'y' ]]; then
  sudo pacman -S ghc
  # curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh # Haskell
fi

# Installing external package managers paru(AUR), flatpak(flathub)
sudo pacman -Syu --noconfirm
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru/
sudo pacman -S --noconfirm flatpak

paru -S --noconfirm "${LANG_COMPILERS_PKGS_PARU[@]}"

# Basic software
UTIL_PKGS=(
  "ttf-jetbrains-mono-nerd"
  "arch-wiki-docs" "arch-wiki-lite"
  "p7zip" "unrar" "tar" "exfat-utils" "ntfs-3g"
  "libreoffice-fresh" "vlc"
  "fastfetch" "btop" # benchmarkers
  "stow" "speedtest-cli" "openbsd-netcat"
  "ufw" # firewall
)
sudo pacman -S --noconfirm "${UTIL_PKGS[@]}"
sudo systemctl enable ufw --now

# Others
QOF_PKGS_PARU=(
  "preload" # to open up software faster
  # "auto-cpufreq"
)
paru -S --noconfirm "${QOF_PKGS_PARU[@]}"
sudo systemctl enable preload --now
# sudo systemctl enable auto-cpufreq --now

# Install extension manager
flatpak install --assumeyes ExtensionManager

# Brave
paru -S --noconfirm brave-bin

# Command line tools
CLI_PKGS=(
  "hub" "github-cli"
  "fzf" "zoxide" "eza" "bat" "fd" "ripgrep" "jq" "less"
  "yazi" "atuin" "gdu" "duf"
  "man-db" 
)
CLI_PKGS_PARU=(
  "tlrc-bin"
  "tio"
  "pipes.sh"
)
sudo pacman -S --noconfirm "${CLI_PKGS[@]}"
paru -S --noconfirm "${CLI_PKGS_PARU[@]}"

# Terminal Emulator tools
TERMINAL_EMULATOR_RELATED_PKGS=(
  "alacritty" "starship" "tmux"
)
sudo pacman -S --noconfirm "${TERMINAL_EMULATOR_RELATED_PKGS[@]}"

# Onedriver
echo "Do you want to install onedriver?(Y/n)"
read usr_input
if [[ "$usr_input" == 'y' ]]; then
  mkdir $HOME/OneDrive
  paru -S --noconfirm onedriver
  rm -rf ~/Music ~/Pictures ~/Templates ~/Public
fi

# Remote machine tools
REMOTE_MACHINE_PKGS=(
  "usbip"
)
REMOTE_MACHINE_PKGS_PARU=(
  "nomachine" "rustdesk-bin" "parsec-bin"
)
sudo pacman -S --noconfirm "${REMOTE_MACHINE_PKGS[@]}"
sudo sh -c "printf '%s\n%s\n' 'usbip-core' 'vhci-hcd' >> /etc/modules-load.d/usbip.conf"
echo "Do you want to install nomachine and rustdesk?(Y/n)"
read usr_input
if [[ "$usr_input" == 'y' ]]; then
  paru -S --noconfirm "${REMOTE_MACHINE_PKGS_PARU[@]}"
fi

# Initialising all dot files
cd ~/.dotfiles
stow .
cd -

# Gnome Config
# Uninstall bloat
GNOME_BLOAT=(
  "epiphany" "gnome-music" "gnome-calendar"
  "gnome-contacts" "sushi" "gnome-weather"
  "totem" "gnome-maps" "gnome-logs" "evince"
)
sudo pacman -Rs --noconfirm "${GNOME_BLOAT[@]}"

# Bring minimise, maximise and close buttons to their positions
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font'

cd ~/Documents
rm -rf install_script_temp_folder

echo "The system will reboot now"

sleep 10
reboot