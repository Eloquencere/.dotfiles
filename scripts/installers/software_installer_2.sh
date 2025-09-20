cd ~/.dotfiles/scripts/installers

echo "Welcome to part 2 of the *Ubuntu 24.04 LTS* installer
This Script configures all the tools installed by the previous installer"
sleep 2

# GUI setup
gnome-text-editor $HOME/.dotfiles/scripts/continual-reference/reference.txt .gui_instructions.txt &

# performance improvement software
sudo nala install -y preload
sudo systemctl enable preload --now

# Kanata install & config
nix profile install nixpkgs#kanata
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER
sudo sh -c "echo '# Kanata
KERNEL==uinput, MODE=0660, GROUP=uinput, OPTIONS+=static_node=uinput' >> /etc/udev/rules.d/99-input.rules"
sudo udevadm control --reload && udevadm trigger --verbose --sysname-match=uniput
sudo sh -c "echo '[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Type=simple
ExecStartPre=/sbin/modprobe uinput
ExecStart=$(which kanata) --cfg $HOME/.config/kanata/config.kbd
Restart=no

[Install]
WantedBy=default.target' > /lib/systemd/system/kanata.service"
sudo systemctl enable kanata --now

# cpanm package manager
cpan App::cpanminus

# # Useful Python libraries
# pip2 install --upgrade pip
# pip install --upgrade pip
# pip install icecream # for debugging
# pip install drawio colorama pyfiglet # presentation
# pip install dash plotly seaborn mysql-connector-python # data representation and calculation
# pip install fireducks xarray openpyxl
# pip install numpy scipy pillow
# pip install Cython numba taichi
# pip install parse pendulum pydantic ruff mypy pyglet
# pip install keras scikit-learn torch # AI/ML
# Electronic Design
# pip install wavedrom pydot python-statemachine

# Useful Rust binaries
CARGO_PKGS=(
    "cargo-expand" "irust" "bacon"
)
cargo install "${CARGO_PKGS[@]}"

echo "file://$HOME/Projects" >> ~/.config/gtk-3.0/bookmarks

mkdir -p $HOME/.config/zsh/personal

echo -n "Enter the ID granted by your admin to register with your team via croc: "
read croc_id
echo "# Croc
export CROC_SELF_TRANSFER_ID=$croc_id" >> $HOME/.config/zsh/personal/zprofile.zsh
echo "Move a copy of the collaborators database given by your admin to the zsh home directory"
mkdir ~/croc-inbox
echo "file://$HOME/croc-inbox" >> ~/.config/gtk-3.0/bookmarks

echo -n "Would you like to log into your git account?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    git config --global init.defaultBranch main
    git config --global core.whitespace error
    git config --global core.preloadindex true
    git config --global core.editor nvim
    git config --global core.pager delta
    git config --global delta.navigate true  # use n and N to move between diff sections
    git config --global delta.dark true
    git config --global delta.side-by-side true
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global diff.colorMoved default
    git config --global merge.conflictstyle diff3
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

echo -n "Will you be Gaming on this machine?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    mkdir ~/Games
    sudo snap install steam discord
    GAMES_FLATPAK=(
        "com.heroicgameslauncher.hgl"
        # "com.parsecgaming.parsec"
    )
    flatpak install --assumeyes flathub "${GAMES_FLATPAK[@]}"
fi

echo -n "Will you be using SAMBA shares on this machine?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    sudo nala install -y samba smbconnect
fi

echo -n "Would you like to configure USBIP?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
	echo -n "Enter the server address: "
	read server_ip
	echo "
# USBIP
export SERVER_IP=$server_ip" >> $HOME/.config/zsh/personal/zprofile.zsh
fi
sudo sh -c " echo '# usbip client
usbip-core
vhci-hcd' > /etc/modules-load.d/usbip.conf"

echo -n "Are you running this on VMWare?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    sudo nala install -y open-vm-tools-desktop
    sudo mkdir -p /mnt/hgfs/{WinLin-Transfer,Workspace-Backups}
    sudo sh -c "echo '.host:/WinLin-Transfer /mnt/hgfs/WinLin-Transfer fuse.vmhgfs-fuse    auto,allow_other    0   0
.host:/Workspace-Backups /mnt/hgfs/Workspace-Backups fuse.vmhgfs-fuse    auto,allow_other    0   0' >> /etc/fstab"
    sed -i "1i\file:///mnt/hgfs/WinLin-Transfer" ~/.config/gtk-3.0/bookmarks
    mkdir -p $HOME/Projects
    sed -i "1i\file://$HOME/Projects" ~/.config/gtk-3.0/bookmarks
fi

# Clean up
BLOAT=(
	"gnome-terminal"
)
sudo nala purge -y "${BLOAT[@]}"

rm -rf ~/.cache/thumbnails/*
rm -rf ~/{.bash*,.profile,.fontconfig}
sudo rm -rf ~/{Templates,Public,go,Music}
sed -i "/Music/d" ~/.config/gtk-3.0/bookmarks
# sed -i "/Videos\|Music/d" ~/.config/gtk-3.0/bookmarks

sudo sh -c "apt-get update; apt-get dist-upgrade; apt-get autoremove; apt-get autoclean; apt --fix-broken install"
flatpak uninstall --unused --delete-data --assumeyes
nix-collect-garbage --delete-old; nix store gc

source $HOME/.dotfiles/scripts/continual-reference/software_updater.zsh

echo -n "Shall we shut down the computer now? (Y/n): "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    shutdown now
fi

# # Auto-cpufreq
# git clone https://github.com/AdnanHodzic/auto-cpufreq.git
# cd auto-cpufreq && sudo ./auto-cpufreq-installer
# cd .. && rm -rf auto-cpufreq
# sudo auto-cpufreq --install

# wine
# ubuntu_codename=$(grep '^UBUNTU_CODENAME=' /etc/os-release | cut -d'=' -f2)
# sudo mkdir -pm755 /etc/apt/keyrings
# wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
# sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/${ubuntu_codename}/winehq-${ubuntu_codename}.sources
# sudo apt update
# sudo apt install -y --install-recommends winehq-stable
# # Can't be installed without a VPN
# wineGUI_version="WineGUI-v2.8.1"
# wget https://winegui.melroy.org/downloads/${wineGUI_version}.deb
# sudo nala install -y ./${wineGUI_version}.deb
# rm -f ${wineGUI_version}.deb

# # Doom Emacs
# sudo nala install -y emacs-gtk
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# echo '# Doom Emacs
# export PATH=$XDG_CONFIG_HOME/emacs/bin:$PATH' >> ~/.zprofile

