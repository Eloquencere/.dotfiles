#!/bin/bsh

echo "Welcome to the *Ubuntu 24.04* installer :)
This script will automatically reboot the system after it is done"
sleep 3

sudo apt update -y && sudo apt upgrade -y

ESSENTIALS=(
	"curl" "sqlite3"
    "ntfs-3g" "exfat-fuse"
	"linux-headers-$(uname -r)" "linux-headers-generic"
	"ubuntu-restricted-extras" "pkg-config" "wl-clipboard"
	"nala"
)
sudo apt-get install -y "${ESSENTIALS[@]}" 
sudo nala fetch

# Fonts
declare -a fonts=(
	JetBrainsMono
)
version=latest
if [[ $version =~ "latest" ]]; then
	version="latest/download"
else
	version="download/${version}"
fi
fonts_dir="${HOME}/.local/share/fonts"
if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi
for font in "${fonts[@]}"; do
	wget https://github.com/ryanoasis/nerd-fonts/releases/${version}/${font}.zip
	unzip ${font} -d ${fonts_dir}
	rm -f ${font}.zip
done
find "$fonts_dir" -name '*Windows Compatible*' -delete
fc-cache -fv

sudo add-apt-repository ppa:linrunner/tlp
sudo apt update
sudo nala install -y tlp
sudo nala install -y preload
sudo systemctl enable tlp preload --now

export CARGO_HOME="$HOME/.local/share/rust/cargo"
export RUSTUP_HOME="$HOME/.local/share/rust/rustup"
LANGUAGE_COMPILERS=(
	"rustup"
	"perl" "ghc"
	"gdb" "valgrind" "strace"
	"clang" "lldb"
    "python3-pip" "tk"
)
sudo nala install -y "${LANGUAGE_COMPILERS[@]}"
rustup toolchain install stable
rustup default stable

sudo snap install julia --classic
sudo snap install zig --classic --beta

APPLICATIONS=(
	"vlc" "gnome-shell-extension-manager"
	"gparted" "bleachbit" "timeshift" 
	"xmonad"
)
sudo nala install -y "${APPLICATIONS[@]}"

sudo nala install distrobox

## https://www.omgubuntu.co.uk/2022/08/pano-clipboard-manager-for-gnome-shell

# ulauncher
sudo add-apt-repository ppa:agornostal/ulauncher
sudo apt update
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
# register the keyboard shortcut with ubuntu

# wine
# run sudo dpgk --i386 # enable 32bit
# sudo apt install wine64
# wineGUI
wget https://winegui.melroy.org/downloads/WineGUI-v2.6.1.deb
sudo apt install -y ./WineGUI-v2.6.1.deb
sudo apt -f install -y
rm -f WineGUI-v2.6.1.deb

# Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install -y wezterm

# zellij - zjstatus plugin
wget -P ~/.local/share/zellij/plugins https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm

# Brave
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

## Chrome
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo apt install -y ./google-chrome-stable_current_amd64.deb
# sudo apt -f install -y
# rm -rf google-chrome-stable_current_amd64.deb

# jitsi meet -> not working very well
# curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
# echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list > /dev/null
# sudo apt update -y
# sudo apt install -y jitsi-meet

# signal
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update
sudo apt install -y signal-desktop
rm -f signal-desktop-keyring.gpg

# Onedriver
sudo add-apt-repository --remove ppa:jstaf/onedriver
sudo apt update
sudo apt install -y onedriver

gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'

gsettings set org.gnome.TextEditor style-scheme 'classic-dark'
gsettings set org.gnome.TextEditor restore-session false
gsettings set org.gnome.TextEditor highlight-current-line true
gsettings set org.gnome.TextEditor highlight-matching-brackets true
gsettings set org.gnome.TextEditor show-line-numbers true

gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.interface clock-format '24h'

echo "Set wezterm as the default terminal"
sudo update-alternatives --config x-terminal-emulator

echo "Set brave/chrome as the default browser"
sudo update-alternatives --config x-www-browser

systemctl daemon-reload

sudo nala install -y zsh
chsh -s $(which zsh)

# After restart
cd ~/.dotfiles/scripts/installers
# package managers
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sh <(curl -L https://nixos.org/nix/install) --daemon
mkdir $HOME/.config/nixpkgs
echo "{ allowUnfree = true; }" >> ~/.config/nixpkgs/config.nix
# restart shell here - maybe sourcing zshrc might suffice

cd ~/.dotfiles
stow .
cd -

# Nix packages
nix-env --install --file cli_pkgs.nix

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

ADDITIONAL_APPS_FLATPAK=( 
   "org.ghidra_sre.Ghidra"
   "net.nokyan.Resources"
   "se.sjoerd.Graphs"
   "io.github.diegoivanme.flowtime"
   "io.github.finefindus.Hieroglyphic"
   "org.gnome.gitlab.somas.Apostrophe"
   "org.gnome.Crosswords"
   "org.gnome.Sudoku"
   "org.gnome.Chess"
   "io.github.nokse22.ultimate-tic-tac-toe"
   "info.febvre.Komikku"
   "org.gnome.World.PikaBackup"
   "com.github.neithern.g4music"
   # "bottles"
)
flatpak install --assumeyes flathub "${ADDITIONAL_APPS_FLATPAK[@]}"

# mise settings set python_compile 1 -> not working very well
# mise use --global node@latest go@latest python@latest python@2.7
# pip install --upgrade pip

echo -n "Enter the ID granted by your admin to register with your team via croc: "
read croc_id
mkdir -p $ZDOTDIR/.confidential
echo "# Croc
export CROC_SELF_TRANSFER_ID=$croc_id" >> $HOME/.config/zsh/.confidential/zprofile.zsh

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

echo -n "Would you like to configure USBIP? (Y/n)"
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
	sudo sh -c " echo '# usbip client
	usbip-core
	vhci-hcd' > /etc/modules-load.d/usbip.conf"
	echo -n "Enter the server address: "
	read server_ip
	echo "# USBIP
export SERVER_IP=$server_ip" >> $ZDOTDIR/.confidential/zprofile.zsh
fi

sudo apt-get purge -y firefox thunderbird
sudo snap remove firefox thunderbird
rm -rf ~/.mozilla
rm -rf ~/{.bash*,.fontconfig,.profile,.sudo_as_admin_successful}

# remove these from Gnome favourates
rm -rf ~/{Templates,Public,Pictures,Videos}
# add this to favourates
mkdir ~/Projects

BLOAT=(
	"curl"
	# disks gnome-terminal
)
sudo apt-get remove -y "${BLOAT[@]}"

sudo sh -c "apt-get update;apt-get dist-upgrade;apt-get autoremove;apt-get autoclean"
sudo apt --fix-broken install

echo "The installer has concluded, it's a good idea to restart"

# cargo install sccache -> needs some packages from openssl, idk what

# correct grouping of apps in the app drawer
# Adding only necessary apps to the dock
# other edits from the original install scripts
# download curlie via nix and alias it with curl
# try the approach of first changing the shell and then, after restart, install *all* the necessary tools
# assign caps lock for left control in kanata & comment the code

# gui instructions
# set the dock at the correct position
# configure the correct DNS servers
# set the position of new icons to the top left
# blur my shell extension(& disable the dash-to-dock effect) etc
# how to configure system fonts

# Reference
## https://kskroyal.com/remove-snap-packages-from-ubuntu/

## distrobox create --name centos --image quay.io/toolbx-images/centos-toolbox
## distrobox create --name rhel --image quay.io/toolbx-images/rhel-toolbox
## distrobox create --name Mint --image docker.io/linuxmintd/mint22-amd64
