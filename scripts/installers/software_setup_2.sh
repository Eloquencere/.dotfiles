cd ~/.dotfiles/scripts/installers

if [[ ! -f "./.temp_file" ]]; then
    echo "Welcome to part 2 of the *Ubuntu 24.04 LTS* installer
Please make sure to run this file again after it concludes"
    sleep 5
    # nix
    sh <(curl -L https://nixos.org/nix/install) --daemon
    mkdir -p $HOME/.config/nixpkgs
    echo "{ allowUnfree = true; }" >> ~/.config/nixpkgs/config.nix

    cd ~/.dotfiles
    stow .
    cd -

    echo "WARNING: ALL BLOAT *WILL* BE REMOVED AFTER THIS
So, PLEASE ensure you are running this on WezTerm from here on"
    echo "Press Enter to close the terminal"
    read user_choice

    touch ./.temp_file
    exit
fi

gnome-text-editor .gui_instructions.txt &

# Nix packages
nix-env --install --file base_pkgs.nix
nix-env --install --file additional_pkgs.nix

# Kanata config
nix-env -iA nixpkgs.kanata
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER
sudo sh -c "echo '# Kanata
KERNEL==uinput, MODE=0660, GROUP=uinput, OPTIONS+=static_node=uinput' >> /etc/udev/rules.d/99-input.rules"
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

mise settings set python_compile 1
mise use --global deno@latest go@latest python@latest python@2.7

echo -n "Would you like to install version control software - PikaBackup?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    echo -n "Install 'OneDriver' also?(y/N) "
    read user_choice
    if [[ $user_choice =~ ^[Yy]$ ]]; then
        sudo sh -c "add-apt-repository -y --remove ppa:jstaf/onedriver; apt update"
        sudo apt install -y onedriver
        mkdir $HOME/OneDrive
        sed -i "1i\file://$HOME/OneDrive" ~/.config/gtk-3.0/bookmarks
    fi
    flatpak install --assumeyes flathub "org.gnome.World.PikaBackup"
    gsettings set org.gnome.shell favorite-apps "['$(xdg-settings get default-web-browser)', 'org.gnome.TextEditor.desktop', 'org.gnome.World.PikaBackup.desktop', 'org.gnome.Nautilus.desktop', 'signal-desktop.desktop','org.wezfurlong.wezterm.desktop']"
fi

echo -n "Are you running this on VMWare?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    sudo nala install -y open-vm-tools-desktop
    sudo sh -c "echo '.host:/ /mnt/hgfs fuse.vmhgfs-fuse    auto,allow_other    0   0' >> /etc/fstab"
    sudo mkdir /mnt/hgfs
    sed -i "1i\file://$HOME/Projects" ~/.config/gtk-3.0/bookmarks
fi

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
	sudo sh -c " echo '# usbip client
	usbip-core
	vhci-hcd' > /etc/modules-load.d/usbip.conf"
	echo -n "Enter the server address: "
	read server_ip
	echo "
# USBIP
export SERVER_IP=$server_ip" >> $HOME/.config/zsh/personal/zprofile.zsh
fi

echo -n "Would you like to log into your git account?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
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


# Clean up
BLOAT=(
	"curl" "transmission-common" "transmission-gtk"
    "rhythmbox" "orca" "info" "yelp"
    "gnome-terminal"
    "gnome-logs" "gnome-system-monitor" "gnome-power-manager"
    "deja-dup" "totem" "seahorse" "remmina" "shotwell"
)
sudo nala purge -y "${BLOAT[@]}"

rm -rf ~/.cache/thumbnails/*
rm -rf ~/{.bash*,.profile,.zcompdump*,.fontconfig}
rm -rf ~/{Templates,Public,Pictures,Videos,Music}
sed -i "/Pictures\|Videos\|Music/d" ~/.config/gtk-3.0/bookmarks

sudo sh -c "apt-get update;apt-get dist-upgrade;apt-get autoremove;apt-get autoclean; apt --fix-broken install"
flatpak uninstall --unused --delete-data

systemctl daemon-reload

rm -f ./.temp_file
echo "The installer has concluded
You can use your system as normal after this restart"
sleep 4
reboot

# Necessary Python libraries
# pip2 install --upgrade pip
# pip install --upgrade pip
# pip install icecream # debugging
# pip install drawio colorama pyfiglet # presentation
# pip install dash plotly seaborn mysql-connector-python # data representation and calculation
# pip install polars xarray
# pip install numpy scipy pillow
# pip install Cython numba taichi
# pip install parse pendulum pydantic ruff mypy pyglet
# pip install keras tensorflow scikit-learn torch

# Useful rust crates
# cargo-expand
# irust" bacon # tokio rayon

# # Doom Emacs
# sudo nala install -y emacs-gtk
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# echo '# Doom Emacs
# export PATH=$XDG_CONFIG_HOME/emacs/bin:$PATH' >> ~/.zprofile

# # wine + GUI
# run sudo dpkg --i386 # enable 32bit
# sudo apt install -y wine64
# wineGUI
# wget https://winegui.melroy.org/downloads/WineGUI-v2.6.1.deb
# sudo apt install -y ./WineGUI-v2.6.1.deb
# sudo apt -f install -y
# rm -f WineGUI-v2.6.1.deb

