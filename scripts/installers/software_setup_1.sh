#!/bin/bash

echo "Welcome to the *Ubuntu 24.04* installer :)
This script will automatically reboot the system after it is done"
sleep 3

sudo dpkg --add-architecture i386
sudo sh -c "apt update; apt upgrade -y"

# install nerd fonts
source nerdfonts_download.sh

ESSENTIALS=(
    "libssl-dev" "liblzma-dev" "libreadline-dev" "libncurses5-dev"
	"sqlite3" "libsqlite3-dev"
    "stow" "curl"
    "ntfs-3g" "exfat-fuse" "wl-clipboard" 
	"linux-headers-$(uname -r)" "linux-headers-generic"
	"ubuntu-restricted-extras" "build-essential" "pkg-config" 
	"nala" "xmonad"
)
sudo apt-get install -y "${ESSENTIALS[@]}" 
sudo nala fetch

# Open in terminal option nautilus extension
wget https://github.com/Stunkymonkey/nautilus-open-any-terminal/releases/latest/download/nautilus-extension-any-terminal_0.6.0-1_all.deb
sudo apt install -y ./nautilus-extension-any-terminal_0.6.0-1_all.deb
rm -f nautilus-extension-any-terminal_0.6.0-1_all.deb

# performance improvement software
sudo add-apt-repository -y ppa:linrunner/tlp
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
    "python3-pip" "tk-dev"
)
sudo nala install -y "${LANGUAGE_COMPILERS[@]}"
rustup toolchain install stable
rustup default stable
cargo install sccache

sudo snap install julia --classic
sudo snap install zig   --classic --beta

APPLICATIONS=(
	"vlc" "gnome-shell-extension-manager"
	"gparted" "bleachbit" # "timeshift"
)
sudo apt install -y "${APPLICATIONS[@]}"

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

# Oh-My-Posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# zellij plugins
## zjstatus
wget -P ~/.local/share/zellij/plugins https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm

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
    sudo sh -c "add-apt-repository -y --remove ppa:jstaf/onedriver; apt update"
    sudo apt install -y onedriver
fi

echo "Set wezterm as the default terminal"
sudo update-alternatives --config x-terminal-emulator

echo "Set brave/chrome as the default browser"
sudo update-alternatives --config x-www-browser

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

echo "The system will reboot now"
sleep 3
reboot

# # ulauncher - Commented out due to high RAM usage
# sudo sh -c "add-apt-repository -y ppa:agornostal/ulauncher; apt update"
# sudo apt install -y ulauncher
# sudo sh -c "echo '[Unit]
# Description=Linux Application Launcher
# Documentation=https://ulauncher.io/
# After=display-manager.service
# 
# [Service]
# Type=simple
# Restart=always
# RestartSec=1
# ExecStart=/usr/bin/ulauncher --hide-window
# 
# [Install]
# WantedBy=graphical.target' > /lib/systemd/system/ulauncher.service"
# sudo systemctl enable ulauncher --now
# sudo rm -f /usr/share/applications/ulauncher.desktop
