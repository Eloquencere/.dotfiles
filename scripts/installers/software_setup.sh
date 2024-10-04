#!/bin/bash

echo "Welcome to the *Linux Mint* installer :)
This script will automatically reboot the system after it is done"
sleep 3

sudo apt update -y && sudo apt upgrade -y

ESSENTIALS=(
	"curl" "ntfs-3g" "stow" "exfat-fuse"
	"linux-headers-$(uname -r)" "linux-headers-generic"
	"openjdk-21-jdk"
)
sudo apt-get install -y "${ESSENTIALS[@]}"

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

# Package managers
sudo apt install -y nala
sudo nala fetch
sh <(curl -L https://nixos.org/nix/install) --daemon
mkdir $HOME/nixpkgs
echo "{ allowUnfree = true; }" >> ~/.config/nixpkgs/config.nix

cd ~/.dotfiles
stow .
cd -

sudo nala install -y zsh
chsh -s $(which zsh)

# Nix packages
nix-env --install --file cli_pkgs.nix

SCENES=(
	"preload" "tlp"
)
sudo nala install -y "${SCENES[@]}"
sudo systemctl enable "${SCENES[@]}" --now

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


LANGUAGE_COMPILERS=(
	"rustup"
	"gdb" "valgrind" "strace" # "ghidra" # unavailable - try flatpak
	"clang" "lldb"
	"perl" "python3-pip" "tk"
	# mise - ghc julia zig
)
sudo nala install -y "${LANGUAGE_COMPILERS[@]}"
rustup toolchain install stable
rustup default stable
cargo install sccache
mise settings set python_compile 1
mise use --global node@latest go@latest python@latest python@2.7
pip install --upgrade pip

APPLICATIONS=(
	"vlc" ""
	"gparted" "bloachbit"
	"alacritty" # "kitty"
)
sudo nala install -y "${APPLICATIONS[@]}"
wget -P ~/.local/share/zellij/plugins https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm

# Brave
sudo apt install curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo apt -f install
rm -rf google-chrome-stable_current_amd64.deb

# jitsi meet
curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list > /dev/null
sudo apt update -y
sudo apt install -y jitsi-meet

# signal
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update
sudo apt install -y signal-desktop
rm -f signal-desktop-keyring.gpg

ADDITIONAL_APPS_FLATPAK=(
   "ExtensionManager"
   # "bottles"
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
   # "com.github.neithern.g4music"
)
flatpak install --assumeyes flathub "${ADDITIONAL_APPS_FLATPAK[@]}"
rm -rf ~/Templates ~/Public

echo -n "Enter the ID granted by your admin to register with your team via croc: "
# echo -n "Enter the croc transfer sequence granted by your admin to register with your team: "
read croc_id
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

echo -n "Would you like to configure USBIP? (Y/n)"
sudo sh -c " echo '# usbip client
usbip-core
vhci-hcd' > /etc/modules-load.d/usbip.conf"
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
   echo "Please enter the server's IP address"
   read server_ip
   echo "# USBIP
export SERVER_IP=$server_ip" >> $ZDOTDIR/.confidential/zprofile.zsh
   source $HOME/.zprofile
fi

rm -rf ~/.bash* ~/.fontconfig
BLOAT=(
	"curl" "irqbalance"
	# disks
)
sudo apt-get remove -y "${BLOAT[@]}"

