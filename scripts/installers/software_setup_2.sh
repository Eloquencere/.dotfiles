#! /bin/bash

echo "Welcome to part 2 of the installer"
sleep 2

# system update
source ../continual-reference/system_updater.zsh

echo -n "Ensure that you are running this on Alacritty (Y/n)"
read usr_input
if [[ $usr_input =~ ^[Nn]$ ]]; then
   exit
fi
# Removing apps and data that couldn't be in the first script
sudo pacman -Rns --noconfirm gnome-console
rm -rf ~/.bash* ~/.fontconfig

# Gnome config
echo "Please follow the instructions below to configure gnome"
cat --line-range=1:4 .gui_instructions.txt
echo "press enter to continue"
read usr_input

# Gnome extensions
cat --line-range=6:17 .gui_instructions.txt
echo "press enter to continue"
read usr_input

mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

mise settings set python_compile 1
mise use --global node@latest go@latest python@latest python@2.7
pip install --upgrade pip

# Browser
echo "Would you like to install brave or google chrome?"
echo -n "b -> brave & gc -> google chrome: "
read browser_choice
if [[ $browser_choice == "b" ]]; then
    paru -S --noconfirm brave-bin
else
    paru -S --noconfirm google-chrome
    mkdir -p $ZDOTDIR/.confidential
    echo "# Browser
export BROWSER=\"chrome\"" >> $ZDOTDIR/.confidential/zprofile.zsh
    source ~/.zprofile
fi

echo -n "Enter the ID granted by your admin to register with your team via croc: "
# echo -n "Enter the croc transfer sequence granted by your admin to register with your team: "
read croc_id
mkdir -p $ZDOTDIR/.confidential
echo "# Croc
export CROC_SELF_TRANSFER_ID=$croc_id" >> $ZDOTDIR/.confidential/zprofile.zsh

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

echo -n "Would you like to configure the server IP address of USBIP? (Y/n)"
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
   echo "Please enter the server's IP address"
   read server_ip
   echo "# USBIP
export SERVER_IP=$server_ip" >> $ZDOTDIR/.confidential/zprofile.zsh
   source $HOME/.zprofile
fi

echo -n "Would you like to initialise Pika for backup to your OneDrive storage account? (Y/n)"
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
    flatpak install --assumeyes flathub org.gnome.World.PikaBackup
    rm -rf ~/Templates ~/Public ~/Pictures ~/Videos
    sed -i "/Pictures/d" ~/.config/gtk-3.0/bookmarks
    sed -i "/Videos/d" ~/.config/gtk-3.0/bookmarks
    mkdir ~/OneDrive
    echo " # OneDrive Mount
rclone mount remote: ~/OneDrive --vfs-cache-mode writes &" >> $ZDOTDIR/.confidential/zprofile.zsh
    echo "Setup backup schedules as well"
fi

echo -n "Would you like to install remote machine software (nomachine, rustdesk, parsec)?(y/n)"
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
    REMOTE_MACHINE_PKGS_PARU=(
      "nomachine" "rustdesk-bin" "parsec-bin"
    )
    paru -S --noconfirm "${REMOTE_MACHINE_PKGS_PARU[@]}"
fi

echo -n "Would you like to install a VM software (virt-manager) ?(y/n)"
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
    # virt-manager with qemu/KVM
    VM_PKGS=(
       "archlinux-keyring"
       "qemu-desktop" "virt-manager" "virt-viewer" "dnsmasq" "vde2" "bridge-utils"
    )
   sudo pacman -S --needed --noconfirm "${VM_PKGS[@]}"
   sudo systemctl enable libvirtd.service --now
   sudo usermod -a -G libvirt $(whoami)
   sudo systemctl restart libvirtd.service
fi

cd ~/Documents
rm -rf install_script_temp_folder

echo "It's a good idea to reboot now"
sleep 2

# # Doom Emacs
# sudo pacman -S emacs-wayland
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# echo '# Doom Emacs
# export "PATH=~/.config/emacs/bin:\$PATH' >> ~/.zprofile

# Necessary Python libraries
# pip install icecream # debugging
# pip install drawio colorama pyfiglet # presentation
# pip install dash plotly seaborn mysql-connector-python # data representation and calculation
# pip install polars xarray
# pip install numpy scipy pillow
# pip install Cython numba taichi
# pip install parse pendulum pydantic ruff mypy pyglet
# pip install keras tensorflow scikit-learn torch

# Useful rust libs
# cargo-expand
# irust" bacon # tokio rayon

