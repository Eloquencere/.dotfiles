#!/bin/bash

echo "Welcome to the *Ubuntu 24.04 LTS* installer :)
This script will automatically reboot the system after it is done"
sleep 3

cd ~/.dotfiles/scripts/installers

sudo dpkg --add-architecture i386
sudo sh -c "apt update; apt upgrade -y"

# install nerd fonts
source nerdfonts_download.sh

ESSENTIALS=(
    "libssl-dev" "liblzma-dev" "libreadline-dev" "libncurses5-dev" "libfuse2t64"
    "sqlite3" "libsqlite3-dev"
    "stow" "curl"
    "ntfs-3g" "exfat-fuse" "wl-clipboard"
    "linux-headers-$(uname -r)" "linux-headers-generic"
    "ubuntu-restricted-extras" "build-essential" "pkg-config" 
    "openjdk-21-jdk" "openjdk-21-jre"
    "nala"
)
sudo apt-get install -y "${ESSENTIALS[@]}" 

# Open in terminal option nautilus extension
wget https://github.com/Stunkymonkey/nautilus-open-any-terminal/releases/latest/download/nautilus-extension-any-terminal_0.6.0-1_all.deb
sudo apt install -y ./nautilus-extension-any-terminal_0.6.0-1_all.deb
rm -f nautilus-extension-any-terminal_0.6.0-1_all.deb
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal wezterm

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
    "gnome-shell-extension-manager" # "vlc"
    "bleachbit" # "gparted"
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

# echo "Set wezterm as the default terminal"
# sudo update-alternatives --config x-terminal-emulator

echo -n "Installing browser
b -> brave
gc -> google chrome
Which one would you like to install? "
read browser_choice
if [[ $browser_choice == "b" ]]; then
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    rm -rf google-chrome-stable_current_amd64.deb
    sudo apt -f install -y
fi

# removing browser bloat
sudo apt-get purge -y firefox thunderbird
sudo snap remove firefox thunderbird
rm -rf ~/.mozilla

# Zsh shell
sudo nala install -y zsh
chsh --shell $(which zsh)

# GNOME appearance
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
sudo wget -P /usr/share/backgrounds https://ubuntucommunity.s3.us-east-2.amazonaws.com/original/3X/3/2/320af712c96e48da2d5a61f9b1d0ab2c792530ed.jpeg
gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/backgrounds/320af712c96e48da2d5a61f9b1d0ab2c792530ed.jpeg"
gsettings set org.gnome.desktop.background picture-options 'stretched'
# GNOME TextEditor config
gsettings set org.gnome.TextEditor style-scheme 'classic-dark'
gsettings set org.gnome.TextEditor restore-session false
gsettings set org.gnome.TextEditor show-line-numbers true
gsettings set org.gnome.TextEditor highlight-current-line true
gsettings set org.gnome.TextEditor highlight-matching-brackets true
# GNOME desktop config
gsettings set org.gnome.shell.extensions.ding show-home false
gsettings set org.gnome.shell.extensions.ding start-corner 'top-left'
gsettings set org.gnome.mutter center-new-windows true
# GNOME dash-to-dock config
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted true
gsettings set org.gnome.shell.extensions.dash-to-dock always-center-icons true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
gsettings set org.gnome.shell favorite-apps "['$(xdg-settings get default-web-browser)', 'org.gnome.TextEditor.desktop', 'org.gnome.Nautilus.desktop', 'signal-desktop.desktop','org.wezfurlong.wezterm.desktop']"
# GNOME interface config
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-format '24h'
# GNOME screen lock behaviour
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
# Trash config
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true

echo "The system will reboot now"
sleep 3
reboot

