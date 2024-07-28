echo "Welcome to part 2 of the installer"
echo "Ensure that you are running this on Alacritty only (y/n)"
read usr_input
if [[ "$usr_input" == "n" ]]; then
   echo "Run this again with alacritty only"
   exit
fi

# system update
source ../continual-reference/system_updater.zsh
echo "Please enter tmux prefix + I to install all plugins"
echo "press enter to continue"
read usr_input

echo "would you like to move the minimal tmux status bar to the top? (y/n)"
read usr_input
if [[ "$usr_input" == "y" ]]; then
   sed -i "s/bottom/top/g" $XDG_CONFIG_HOME/tmux/plugins/minimal-tmux-status/minimal.tmux
fi
echo "Press tmux prefix + r to reload the config file"
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

mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Uninstall bloat
BLOAT_PKGS_PACMAN=(
  "vim" "htop" "nano"
  "epiphany" "gnome-music" "gnome-calendar" "gnome-console"
  "gnome-contacts" "sushi" "gnome-weather"
  "totem" "gnome-maps" "gnome-logs" "evince"
)
sudo pacman -Rs --noconfirm "${BLOAT_PKGS_PACMAN[@]}"
rm -rf ~/.bash*

# Necessary Python libraries
pyenv install 3.12
pyenv global 3.12
source ~/.zprofile
source ~/.config/zsh/.zshrc
# pyenv shell 3.12
pip install --upgrade pip
PIP_PKGS=(
   # debugging
   "icecream"
   # presentation
   "drawio"
   "colorama" "pyfiglet"
   # data representation and calculation
   "dash" "plotly" "seaborn" # seaborn - (replace matplotlib)
   "mysql-connector-python"
   "polars" "xarray" # xarray - (multi-dimentional arrays)
   "Cython" "numba" "taichi"
   "numpy" "scipy" "pillow"
   # quality of life
   "parse"
   "pendulum" # replaces datetime
   "pydantic"
   "ruff" # linter
   "mypy" # static typing
   "pyglet" # best game engine
   # "keras" "tensorflow" "scikit-learn" "torch"
)
pip install "${PIP_PKGS[@]}"

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

# # Windows Emulator
# flatpak install --assumeyes bottles

# # Cool tools
# flatpak install --assumeyes info.febvre.Komikku
# flatpak install --assumeyes flathub org.gnome.World.PikaBackup
# flatpak install --assumeyes flathub se.sjoerd.Graphs
# sudo pacman -S --noconfirm obsidian zathura

# Kanata
paru -S --noconfirm kanata-bin
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER
sudo sh -c 'echo KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput" > /etc/udev/rules.d/99-input.rules'
sudo udevadm control --reload && udevadm trigger --verbose --sysname-match=uniput
sudo ln -s $HOME/.config/kanata /etc/
sudo sh -c "echo '[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Type=simple
ExecStartPre=/sbin/modprobe uinput
ExecStart=$(which kanata) --cfg /etc/kanata/config.kbd
Restart=no

[Install]
WantedBy=default.target' > /lib/systemd/system/kanata.service"

sudo systemctl enable kanata --now

# # Doom Emacs
# sudo pacman -S emacs-wayland
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# echo "export PATH=~/.config/emacs/bin:\$PATH" >> ~/.zprofile

cd ~/Documents
rm -rf install_script_temp_folder
