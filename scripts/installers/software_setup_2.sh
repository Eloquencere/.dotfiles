if [[ ! -f "./.temp_file" ]]; then
    echo "Welcome to part 2 of the installer
Please make sure to run this file again after it concludes"
    sleep 5
    # package managers
    sudo apt install -y flatpak gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    sh <(curl -L https://nixos.org/nix/install) --daemon
    mkdir -p $HOME/.config/nixpkgs
    echo "{ allowUnfree = true; }" >> ~/.config/nixpkgs/config.nix

    cd ~/.dotfiles
    stow .
    cd -

    touch ./.temp_file
    echo "WARNING: ALL BLOAT *WILL* BE REMOVED AFTER THIS
So, PLEASE ensure you are running this on WezTerm from here on"
    echo "Press Enter to close the terminal"
    read user_choice
    exit
fi

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

# zellij plugins
## zjstatus
wget -P ~/.local/share/zellij/plugins https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm

# echo "While your software take time to install, finish up some GUI setup"
# sleep 3
# gnome-text-editor ../continual-reference/DNS.txt .gui_instructions.txt &
## gui instructions
# set the dock at the correct position
# configure the correct DNS servers
# set the position of new icons to the top left
# blur my shell extension(& disable the dash-to-dock effect) etc
# steps to configure system fonts
# Optional - register the keyboard shortcut of ulauncher with ubuntu
# Optional - set when or if your screen should go to sleep

ADDITIONAL_APPS_FLATPAK=(
   "org.ghidra_sre.Ghidra"
   "net.nokyan.Resources"
   "se.sjoerd.Graphs"
   "bottles"
   "io.github.diegoivanme.flowtime"
   "io.github.finefindus.Hieroglyphic"
   # "org.gnome.gitlab.somas.Apostrophe"
   # consumption
   "info.febvre.Komikku"
   # "com.github.neithern.g4music"
   # Games
   "io.github.nokse22.ultimate-tic-tac-toe"
   "org.gnome.Crosswords"
   "org.gnome.Chess"
   "org.gnome.Sudoku"
   "org.gnome.Mahjongg" 
   "org.gnome.Mines"
   "app.drey.MultiplicationPuzzle"
)
flatpak install --assumeyes flathub "${ADDITIONAL_APPS_FLATPAK[@]}"

mise settings set python_compile 1
mise use --global deno@latest go@latest python@latest python@2.7

echo -n "Would you like to install version control software(PikaBackup,timeshift)?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    echo -n "Install 'OneDriver' also?(y/N) "
    read user_choice
    if [[ $user_choice =~ ^[Yy]$ ]]; then
        sudo sh -c "add-apt-repository -y --remove ppa:jstaf/onedriver; apt update"
        onedriver="onedriver"
        mkdir $HOME/OneDrive
        sed -i "1i\file://$HOME/OneDrive" ~/.config/gtk-3.0/bookmarks
    fi
    flatpak install --assumeyes flathub "org.gnome.World.PikaBackup"
    sudo apt install -y timeshift ${onedriver}
fi

echo -n "\nWould you like to install ULauncher?
WARNING: This software uses an extremely high amount of RAM (y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    sudo sh -c "add-apt-repository -y ppa:agornostal/ulauncher; apt update"
    sudo apt install -y ulauncher
    sudo sh -c "echo '[Unit]
Description=Linux Application Launcher
Documentation=https://ulauncher.io/
After=display-manager.service

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/usr/bin/ulauncher --hide-window

[Install]
WantedBy=graphical.target' > /lib/systemd/system/ulauncher.service"
    sudo systemctl enable ulauncher --now
    sudo rm -f /usr/share/applications/ulauncher.desktop
fi

mkdir -p $HOME/.config/zsh/personal

echo -n "Enter the ID granted by your admin to register with your team via croc: "
read croc_id
echo "# Croc
export CROC_SELF_TRANSFER_ID=$croc_id" >> $HOME/.config/zsh/personal/zprofile.zsh
mkdir -p $HOME/.local/share/croc

echo -n "Would you like to configure USBIP?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
	sudo sh -c " echo '# usbip client
	usbip-core
	vhci-hcd' > /etc/modules-load.d/usbip.conf"
	echo -n "Enter the server address: "
	read server_ip
	echo "# USBIP
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
    "gnome-terminal" "nautilus-extension-gnome-terminal"
    "gnome-logs" "gnome-system-monitor" "gnome-power-manager"
    "deja-dup" "totem" "seahorse" "remmina" "shotwell"
)
sudo nala purge -y "${BLOAT[@]}"

rm -rf ~/.cache/thumbnails/*
rm -rf ~/{.bash*,.profile,.zcompdump*,.fontconfig}
rm -rf ~/{Templates,Public,Pictures,Videos,Music}
sed -i "/Pictures\|Videos\|Music/d" ~/.config/gtk-3.0/bookmarks
mkdir ~/{Projects,croc-inbox}
sed -i "1i\file://$HOME/croc-inbox" ~/.config/gtk-3.0/bookmarks
sed -i "1i\file://$HOME/Projects" ~/.config/gtk-3.0/bookmarks

sudo sh -c "apt-get update;apt-get dist-upgrade;apt-get autoremove;apt-get autoclean"
sudo apt --fix-broken install
flatpak uninstall --unused --delete-data

systemctl daemon-reload

rm -f ./.temp_file
echo "The installer has concluded, it's a good idea to restart"

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

# Useful rust libs
# cargo-expand
# irust" bacon # tokio rayon

# # Doom Emacs
# sudo nala install -y emacs-gtk
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# echo '# Doom Emacs
# export PATH=$XDG_CONFIG_HOME/emacs/bin:$PATH' >> ~/.zprofile


#### Don't touch unless you know what you are doing ###
#
# # wine + GUI
# run sudo dpgk --i386 # enable 32bit
# sudo apt install -y wine64
# wineGUI
# wget https://winegui.melroy.org/downloads/WineGUI-v2.6.1.deb
# sudo apt install -y ./WineGUI-v2.6.1.deb
# sudo apt -f install -y
# rm -f WineGUI-v2.6.1.deb
#
# https://www.omgubuntu.co.uk/2022/08/pano-clipboard-manager-for-gnome-shell

