#!/bin/bsh

echo "Welcome to the *Linux Mint* installer :)
This script will automatically reboot the system after it is done"
sleep 3

sudo apt update -y && sudo apt upgrade -y

ESSENTIALS=(
	"curl" "ntfs-3g" "stow" "exfat-fuse" "sqlite3"
	"linux-headers-$(uname -r)" "linux-headers-generic"
	"openjdk-21-jdk" "ubuntu-restricted-extras" "pkg-config"
	"nala"
)
sudo apt-get install -y "${ESSENTIALS[@]}" 
sudo nala fetch

rm -rf ~/Templates ~/Public ~/Pictures ~/Videos

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
SCENES=(
	"preload" "tlp"
)
sudo nala install -y "${SCENES[@]}"
sudo systemctl enable "${SCENES[@]}" --now

export CARGO_HOME="$HOME/.local/share/rust/.cargo"
export RUSTUP_HOME="$HOME/.local/share/rust/.rustup"
LANGUAGE_COMPILERS=(
	"rustup"
	"gdb" "valgrind" "strace" # "ghidra" # unavailable - try flatpak
	"clang" "lldb"
	"perl" "python3-pip" "tk"
)
sudo nala install -y "${LANGUAGE_COMPILERS[@]}"
rustup toolchain install stable
rustup default stable

APPLICATIONS=(
	"vlc" "gnome-shell-extension-manager"
	"gparted" "bleachbit" "timeshift"
)
sudo nala install -y "${APPLICATIONS[@]}"

wget -P ~/.local/share/zellij/plugins https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm

# Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install wezterm

# Brave
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update -y
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
sudo apt update -y
sudo apt install -y signal-desktop
rm -f signal-desktop-keyring.gpg

sudo nala install -y zsh
chsh -s $(which zsh)

cd ~/.dotfiles
stow .
cd -

gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
systemctl daemon-reload

# After restart
rm -rf ~/.bash* ~/.fontconfig
BLOAT=(
	"curl"
	# disks
)
sudo apt-get remove -y "${BLOAT[@]}"

# package managers
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sh <(curl -L https://nixos.org/nix/install) --daemon
mkdir $HOME/.config/nixpkgs
echo "{ allowUnfree = true; }" >> ~/.config/nixpkgs/config.nix
# restart shell here - maybe sourcing zshrc might suffice

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
   # "bottles"
   # "com.github.neithern.g4music"
)
flatpak install --assumeyes flathub "${ADDITIONAL_APPS_FLATPAK[@]}"

# mise - ghc julia zig
# mise settings set python_compile 1 -> not working very well
mise use --global node@latest go@latest python@latest python@2.7
pip install --upgrade pip

echo -n "Enter the ID granted by your admin to register with your team via croc: "
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

echo -n "Would you like to configure USBIP? (Y/n)"
read usr_input
if [[ $usr_input =~ ^[Yy]$ ]]; then
	sudo sh -c " echo '# usbip client
	usbip-core
	vhci-hcd' > /etc/modules-load.d/usbip.conf"
	echo -n "Enter the server address: "
	read usr_input
	echo "Please enter the server's IP address"
	read server_ip
	echo "# USBIP
export SERVER_IP=$server_ip" >> $ZDOTDIR/.confidential/zprofile.zsh
	source $HOME/.zprofile
fi

# cargo install sccache -> needs some packages from openssl, idk what

# open new apps on the top left
# correct grouping of apps in the app drawer
# Adding only necessary apps to the dock
# dash to dock config to enable click on icon to minimise
# astra monitor, user themes, blur my shell - GNOME shell extensions
# blur my shell extension(& disable the dash-to-dock effect) etc 
# gui instruction, on how to configgure fonts
# other edits from the original install scripts
# fix croc

# Reference
## https://kskroyal.com/remove-snap-packages-from-ubuntu/
