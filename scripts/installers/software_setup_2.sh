echo "Welcome to part 2 of the installer"
echo -n "Ensure that you are running this on Alacritty & TMUX(green line at the bottom) only (Y/n)"
read usr_input
if [[ $usr_input =~ ^[Nn]$ ]]; then
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

echo -n "Would you like to configure the server IP address of USBIP? (Y/n)"
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
   echo "Please enter the server's IP address"
   read server_ip
   mkdir $ZDOTDIR/.confidential
   echo "export SERVER_IP=$server_ip" >> $ZDOTDIR/.confidential/zprofile.zsh
   source $HOME/.zprofile
fi

echo -n "Would you like to log into your git account? (Y/n)"
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
	echo "[core]
	editor = nvim
	pager = delta
[init]
	defaultBranch = main  
[interactive]
	diffFilter = delta --color-only
[delta]
	navigate = true    # use n and N to move between diff sections
	dark = true
	side-by-side = true
[merge]
	conflictstyle = diff3
[diff]
	colorMoved = default" > $HOME/.gitconfig
    echo -n "email ID: "
    read email
    git config --global user.email "$email"
    echo -n "username: "
    read username
    git config --global user.name "$username"
    echo "you need to login to Github as well"
    gh auth login
    sed -i '/.* = $/d' $HOME/.gitconfig
fi

echo -n "Would you like to setup your cloud file storage client?(Y/n)"
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
	rm -rf ~/Pictures ~/Templates ~/Public ~/Videos
	echo "Open settings/Online Accounts and log into your provider"
	echo -n "Would you like to sym-link the cloud directory to your home directory?(Y/n)"
	read usr_input
	if [[ $usr_input =~ ^[Yy]$ ]]; then
		echo -n "Enter the absolute path to the cloud directory: "
		read path
		ln -s $path $HOME
	fi
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

rtx install bun@latest
rtx install python@2.7

# Necessary Python libraries
# pip install --upgrade pip
# pip install icecream # debugging
# pip install drawio colorama pyfiglet # presentation
# pip install dash plotly seaborn mysql-connector-python # data representation and calculation
# pip install polars xarray
# pip install numpy scipy pillow
# pip install Cython numba taichi
# pip install parse pendulum pydantic ruff mypy pyglet
# pip install keras tensorflow scikit-learn torch

# virt-manager with qemu/KVM
VM_PKGS=(
   "archlinux-keyring"
   "qemu-desktop" "virt-manager" "virt-viewer" "dnsmasq" "vde2" "bridge-utils"
)
echo -n "Would you like to install a VM software?(y/n)"
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
   sudo pacman -Syu --noconfirm
   sudo pacman -S --needed --noconfirm "${VM_PKGS[@]}"
   sudo systemctl enable libvirtd.service --now
   sudo usermod -a -G libvirt $(whoami)
   sudo systemctl restart libvirtd.service
fi

# Cool tools
ADDITIONAL_TOOLS_FLATPAK=(
   "bottles"
   "se.sjoerd.Graphs"
   "info.febvre.Komikku"
   "org.gnome.Crosswords"
   "org.gnome.Sudoku"
   "org.gonme.Chess"
   "org.gnome.World.PikaBackup"
   "io.github.finefindus.Hieroglyphic"
   "org.gnome.gitlab.somas.Apostrophe"
   # "com.github.neithern.g4music"
)
ADDITIONAL_TOOLS_PACMAN=(
   "obsidian" "zathura"
   "signal-desktop"
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
