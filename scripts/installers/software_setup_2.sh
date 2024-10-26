if [[ ! -f "./.temp_file" ]]; then
    echo "Welcome to part 2 of the installer
Please make sure to run this file again after it concludes"
    sleep 5
    cd ~/.dotfiles/scripts/installers
    # package managers
    sudo apt install -y flatpak gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    sh <(curl -L https://nixos.org/nix/install) --daemon
    mkdir $HOME/.config/nixpkgs
    echo "{ allowUnfree = true; }" >> ~/.config/nixpkgs/config.nix

    cd ~/.dotfiles
    stow .
    cd -

    touch ./.temp_file
    echo "The shell needs to be restarted for all changes to take effect"
    echo "Please ensure you are running the defaul editor since all bloat will be removed"
    echo "Press Enter to close the terminal"
    read user_input
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

# echo "While your software take time to install, finish up some GUI setup"
# sleep 3
# gnome-text-editor .gui_instructions.txt &
## gui instructions
# set the dock at the correct position
# configure the correct DNS servers
# set the position of new icons to the top left
# blur my shell extension(& disable the dash-to-dock effect) etc
# steps to configure system fonts
# register the keyboard shortcut of ulauncher with ubuntu

ADDITIONAL_APPS_FLATPAK=( 
   # "org.jitsi.jitsi-meet"
   "org.ghidra_sre.Ghidra"
   "net.nokyan.Resources"
   "se.sjoerd.Graphs"
   "bottles"
   "io.github.diegoivanme.flowtime"
   "io.github.finefindus.Hieroglyphic"
   # "org.gnome.gitlab.somas.Apostrophe"
   # consumption
   "info.febvre.Komikku"
   "org.gnome.World.PikaBackup"
   "com.github.neithern.g4music"
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
# pip install --upgrade pip
# Issue: python2.7 gnu readline lib, sqlite3 lib, tk toolkit not found

mkdir -p $HOME/.config/zsh/personal

echo -n "Enter the ID granted by your admin to register with your team via croc: "
read croc_id
echo "# Croc
export CROC_SELF_TRANSFER_ID=$croc_id" >> $HOME/.config/zsh/personal/zprofile.zsh

echo -n "Would you like to log into your git account?(y/N) "
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

echo -n "Would you like to configure USBIP?(y/N) "
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
	sudo sh -c " echo '# usbip client
	usbip-core
	vhci-hcd' > /etc/modules-load.d/usbip.conf"
	echo -n "Enter the server address: "
	read server_ip
	echo "# USBIP
export SERVER_IP=$server_ip" >> $HOME/.config/zsh/personal/zprofile.zsh
fi

rm -rf ~/{.bash*,.fontconfig,.profile,.sudo_as_admin_successful,.wget-hsts,.zcompdump}
rm -rf ~/{Templates,Public,Pictures,Videos}
sed -i "/Pictures/d" ~/.config/gtk-3.0/bookmarks
sed -i "/Videos/d" ~/.config/gtk-3.0/bookmarks
mkdir ~/{Projects,croc-inbox}
sed -i "1i\file://$HOME/croc-inbox" ~/.config/gtk-3.0/bookmarks
sed -i "1i\file://$HOME/Projects" ~/.config/gtk-3.0/bookmarks

sudo apt-get purge -y firefox thunderbird
sudo snap remove firefox thunderbird
rm -rf ~/.mozilla
BLOAT=(
	"curl" "transmission-common" "transmission-gtk"
    "rhythmbox" "gnome-logs" "orca"
    "gnome-terminal" "gnome-disk-utility" "gnome-system-monitor" "gnome-power-manager"
    "deja-dup" "totem" "info" "yelp" "seahorse" "remmina" "shotwell"
)
sudo nala purge -y "${BLOAT[@]}"

# Group apps in app drawer

# Clean up
sudo sh -c "apt-get update;apt-get dist-upgrade;apt-get autoremove;apt-get autoclean"
sudo apt --fix-broken install
flatpak uninstall --unused --delete-data

rm -f ./.temp_file
echo "The installer has concluded, it's a good idea to restart"

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

# # Doom Emacs
# sudo nala install -y emacs-gtk
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# echo '# Doom Emacs
# export PATH=$XDG_CONFIG_HOME/emacs/bin:\$PATH' >> ~/.zprofile


#### Don't touch unless you know what you are doing ###
## jitsi meet -> not working very well
# curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
# echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list > /dev/null
# sudo apt update -y
# sudo apt install -y jitsi-meet
#
## wine + GUI
# run sudo dpgk --i386 # enable 32bit
# sudo apt install wine64
# wineGUI
# wget https://winegui.melroy.org/downloads/WineGUI-v2.6.1.deb
# sudo apt install -y ./WineGUI-v2.6.1.deb
# sudo apt -f install -y
# rm -f WineGUI-v2.6.1.deb
#
# https://www.omgubuntu.co.uk/2022/08/pano-clipboard-manager-for-gnome-shell
#
# echo -n "Would you like to install remote machine software (thinlic, rustdesk, parsec)?(y/N) "
# read usr_input
# if [[ $usr_input =~ ^[Yy]$ ]]; then
# fi
