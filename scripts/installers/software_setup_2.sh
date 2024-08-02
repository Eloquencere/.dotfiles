echo "Welcome to part 2 of the installer"
echo "Ensure that you are running this on Alacritty only & TMUX(green line at the bottom) on (y/n)"
read usr_input
if [[ "$usr_input" == "n" ]]; then
   exit
fi

# system update
source ../continual-reference/system_updater.zsh
echo "Please enter tmux prefix + Shift + I to install all plugins"
echo "press enter to continue"
read usr_input
sed -i "s/bottom/top/g" $XDG_CONFIG_HOME/tmux/plugins/minimal-tmux-status/minimal.tmux
echo "Press tmux prefix + R to reload the config file"
echo "press enter to continue"
read usr_input

# Gnome config
echo "Please follow the instructions below to configure gnome"
cat --line-range=1:4 .gui_instructions.txt
echo "press enter to continue"
read usr_input

# Gnome extensions
cat --line-range=6:17 .gui_instructions.txt
echo "press enter to continue"
read usr_input

echo "Would you like to configure the server IP address of USBIP? (y/n)"
read usr_input
if [[ "$usr_input" == "y" ]]; then
   echo "Please enter the server's IP address"
   read server_ip
   sed -i "s/^\(SERVER_IP=\).*/\1$server_ip/g" $ZDOTDIR/zsh-functions.zsh
   source $ZDOTDIR/.zshrc
fi

echo "Would you like to log into your git account? (y/n)"
read usr_input
if  [[ "$usr_input" == "y" ]]; then
    echo "what is your username?"
    read username
    sed -i "s|^\s+\(name = \).*|\1$username|g" $HOME/.gitconfig
    echo "what is your email?"
    read email
    sed -i "s|^\s+\(email = \).*|\1$email|g" $HOME/.gitconfig
    echo "you need to login to Github as well"
    echo "Here is your email id - $email"
    gh auth login
fi

mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Uninstall bloat
BLOAT_PKGS_PACMAN=(
  "vim" "htop" "nano"
  "epiphany" "gnome-music" "gnome-calendar" "gnome-console"
  "gnome-contacts" "sushi" "gnome-weather" "gnome-tour"
  "totem" "gnome-maps" "gnome-logs" "evince" "orca"
)
sudo pacman -Rs --noconfirm "${BLOAT_PKGS_PACMAN[@]}"
rm -rf ~/.bash* ~/.fontconfig

# Necessary Python libraries
rtx install python@3.12
rtx global python@3.12
source ~/.zprofile
pip install --upgrade pip

pip install icecream # debugging
pip install drawio colorama pyfiglet # presentation
pip install dash plotly seaborn mysql-connector-python # data representation and calculation
pip install polars xarray
pip install numpy scipy pillow
pip install Cython numba taichi
pip install parse pendulum pydantic ruff mypy pyglet
# pip install keras tensorflow scikit-learn torch

# virt-manager with qemu/KVM
VM_PKGS=(
   "archlinux-keyring"
   "qemu-desktop" "virt-manager" "virt-viewer" "dnsmasq" "vde2" "bridge-utils"
)
echo "do you want to install a VM software?(y/n)"
read usr_input
if [[ "$usr_input" == "y" ]]; then
   sudo pacman -Syu --noconfirm
   sudo pacman -S --needed --noconfirm "${VM_PKGS[@]}"
   sudo systemctl enable libvirtd.service --now
   sudo usermod -a -G libvirt $(whoami)
   sudo systemctl restart libvirtd.service
fi

# Cool tools
ADDITIONAL_TOOLS_FLATPAK=(
   "bottles"
   "info.febvre.Komikku"
   "org.gnome.World.PikaBackup"
   "se.sjoerd.Graphs"
)
ADDITIONAL_TOOLS_PACMAN=(
   "obsidian" "zathura"
)
# flatpak install --assumeyes flathub "${ADDITIONAL_TOOLS_FLATPAK[@]}"
# sudo pacman -S --noconfirm "${ADDITIONAL_TOOLS_PACMAN[@]}"

# # Doom Emacs
# sudo pacman -S emacs-wayland
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# echo "# Doom Emacs
# export "PATH=~/.config/emacs/bin:\$PATH" >> ~/.zprofile

cd ~/Documents
rm -rf install_script_temp_folder
