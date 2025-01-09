cd ~/.dotfiles/scripts/installers

echo "Welcome to part 2 of the *Ubuntu 24.04 LTS* installer"
sleep 2

# Kanata install & config
nix-env -iA nixpkgs.kanata
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

# GUI setup
gnome-text-editor .gui_instructions.txt $HOME/.dotfiles/scripts/continual-reference/reference.txt &

# Useful Python libraries
pip2 install --upgrade pip
pip install --upgrade pip
pip install icecream # for debugging
pip install drawio colorama pyfiglet # presentation
pip install dash plotly seaborn mysql-connector-python # data representation and calculation
pip install fireducks xarray
pip install numpy scipy pillow
pip install Cython numba taichi
pip install parse pendulum pydantic ruff mypy pyglet
pip install keras scikit-learn torch # AI/ML

# Useful Rust binaries
CARGO_PKGS=(
    "cargo-expand" "irust" "bacon"
)
cargo install "${CARGO_PKGS[@]}"

mkdir -p $HOME/.config/zsh/personal

echo -n "Enter the ID granted by your admin to register with your team via croc: "
read croc_id
echo "# Croc
export CROC_SELF_TRANSFER_ID=$croc_id" >> $HOME/.config/zsh/personal/zprofile.zsh
mkdir -p $HOME/.local/share/croc
mkdir ~/croc-inbox
echo "file://$HOME/croc-inbox" >> ~/.config/gtk-3.0/bookmarks

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

echo -n "Would you like to log into your git account?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    git config --global init.defaultBranch main
    git config --global core.editor nvim
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.navigate true  # use n and N to move between diff sections
    git config --global delta.dark true
    git config --global delta.side-by-side true
    git config --global merge.conflictstyle diff3
    git config --global diff.colorMoved default
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
rm -rf ~/{Templates,Public,Pictures,Videos,Music}
sed -i "/Pictures\|Videos\|Music/d" ~/.config/gtk-3.0/bookmarks

sudo sh -c "apt-get update; apt-get dist-upgrade; apt-get autoremove; apt-get autoclean; apt --fix-broken install"
flatpak uninstall --unused --delete-data --assumeyes
nix-collect-garbage -d

source $HOME/.dotfiles/scripts/continual-reference/software_updater.zsh

echo "The system will reboot one last time"
sleep 3

reboot

# Useful rust crates - tokio rayon

# # Doom Emacs
# sudo nala install -y emacs-gtk
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# echo '# Doom Emacs
# export PATH=$XDG_CONFIG_HOME/emacs/bin:$PATH' >> ~/.zprofile

