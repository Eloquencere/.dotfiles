#!/bin/bash

echo "Welcome to the *Ubuntu 24.04* installer :)
This script will automatically reboot the system after it is done"
sleep 3

sudo sh -c "apt update; apt upgrade -y"

# install nerd fonts
source nerdfonts_download.sh

ESSENTIALS=(
	"curl" "sqlite3"
    "stow" "build-essential"
    "ntfs-3g" "exfat-fuse"
    "libssl-dev" "liblzma-dev"
	"linux-headers-$(uname -r)" "linux-headers-generic"
	"ubuntu-restricted-extras" "pkg-config" "wl-clipboard"
	"nala" "xmonad"
)
sudo apt-get install -y "${ESSENTIALS[@]}" 
sudo nala fetch

# Open in terminal option nautilus extension
wget https://github.com/Stunkymonkey/nautilus-open-any-terminal/releases/latest/download/nautilus-extension-any-terminal_0.6.0-1_all.deb
sudo apt install -y ./nautilus-extension-any-terminal_0.6.0-1_all.deb
rm -f nautilus-extension-any-terminal_0.6.0-1_all.deb

# performance improvement software
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
cargo install sccache

sudo snap install julia --classic
sudo snap install zig   --classic --beta

APPLICATIONS=(
	"gnome-shell-extension-manager"
	"gparted" "bleachbit" "timeshift" 
)
sudo nala install -y "${APPLICATIONS[@]}"

# signal
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update
sudo apt install -y signal-desktop
rm -f signal-desktop-keyring.gpg

# Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install -y wezterm

# zellij plugins
## zjstatus
wget -P ~/.local/share/zellij/plugins https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm

# ulauncher
sudo sh -c "add-apt-repository ppa:agornostal/ulauncher; apt update"
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

echo "Would you like to install Brave or Google Chrome?"
echo -n "b -> brave & gc -> google chrome: "
read browser_choice
if [[ $browser_choice == "b" ]]; then
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    sudo apt -f install -y
    rm -rf google-chrome-stable_current_amd64.deb
fi

echo -n "Would you like to install OneDriver? (Y/n) "
read user_input
if [[ $user_input =~ ^[Yy]$ ]]; then
    sudo sh -c "add-apt-repository --remove ppa:jstaf/onedriver; apt update"
    sudo apt install -y onedriver
fi

echo "Set wezterm as the default terminal"
sudo update-alternatives --config x-terminal-emulator

echo "Set brave/chrome as the default browser"
sudo update-alternatives --config x-www-browser

# GNOME nautilus-open-any-terminal config
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal wezterm
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak system
# GNOME dash-to-dock config
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
# GNOME TextEditor config
gsettings set org.gnome.TextEditor style-scheme 'classic-dark'
gsettings set org.gnome.TextEditor restore-session false
gsettings set org.gnome.TextEditor highlight-current-line true
gsettings set org.gnome.TextEditor highlight-matching-brackets true
gsettings set org.gnome.TextEditor show-line-numbers true
# GNOME window & interface config
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.interface clock-format '24h'

sudo nala install -y zsh
chsh --shell $(which zsh)

systemctl daemon-reload

echo "The system will reboot now"
sleep 3
reboot

