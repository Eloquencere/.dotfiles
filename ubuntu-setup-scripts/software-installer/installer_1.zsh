#!/bin/zsh

# For ubuntu autoinstall
#   Disk partitions
#   install zsh & make it default install git & stow
#
# sudo dpkg --add-architecture i386
# sudo sh -c "apt update; apt upgrade -y"
#
# The uncommented part of the following
# ESSENTIALS=(
#     "linux-headers-$(uname -r)" "linux-headers-generic" "build-essential" "pkg-config"
#     "ntfs-3g" "exfat-fuse" "sshfs"
# )
# sudo apt install -y "${ESSENTIALS[@]}"


# Need to implement software_updater as well

cd "$(dirname "${(%):-%x}")" # change directory to script location

echo "Welcome to the *Ubuntu 26.04 LTS* installer :)
This script is designed to install as much as possible without human intervention
It will automatically reboot the system after it is done"

# To prevent the machine from going to sleep during install
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
# Load wallpaper once
gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/.dotfiles/wallpapers/angkor_watt_gpt.png"
gsettings set org.gnome.desktop.background picture-options 'stretched'

# Install Necessary fonts
source nerdfonts_download.sh
MS_FONTS=( # For LibreOffice
    "ttf-mscorefonts-installer"
    "fonts-crosextra-carlito" "fonts-crosextra-caladea"
)
sudo apt install -y "${MS_FONTS[@]}"

# WARN: need to check which one of these already comes installed & if it is not, use nix
# debatable, be very careful
LANGUAGE_COMPILERS=(
    "gcc" "make" # leave it here
    "gdb" "valgrind" "strace"
    "clang" "lldb"
    "perl" # NEVER uninstall
    "python3-pip" "tk-dev"
)
sudo apt install -y "${LANGUAGE_COMPILERS[@]}"

# performance improvement software
sudo apt install -y preload
sudo systemctl enable preload

# install antivirus & firewall - https://www.google.com/search?q=ClamAV+ubuntu&sca_esv=f755b356225138a1&sxsrf=ANbL-n4fWqEN-yAfs7Kaq_9RZ3spcphnBg%3A1771209979410&ei=-4SSafvdGLzk5NoP1M3BiQ0&biw=1597&bih=785&ved=0ahUKEwi7x5St_9ySAxU8MlkFHdRmMNEQ4dUDCBM&uact=5&oq=ClamAV+ubuntu&gs_lp=Egxnd3Mtd2l6LXNlcnAiDUNsYW1BViB1YnVudHUyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBhAAGBYYHjIGEAAYFhgeMgYQABgWGB4yBhAAGBYYHkj5DFD6AVibC3ABeAGQAQCYAYwBoAH8A6oBAzYuMbgBA8gBAPgBAZgCCKACtQTCAgoQABiwAxjWBBhHwgINEAAYgAQYsAMYQxiKBcICChAAGIAEGEMYigWYAwCIBgGQBgqSBwM3LjGgB_UjsgcDNi4xuAevBMIHAzItOMgHLIAIAA&sclient=gws-wiz-serp
APPLICATIONS=(
    "gnome-shell-extension-manager"
    "bleachbit" "timeshift"
    "kdeconnect" "gufw"
)
sudo apt install -y "${APPLICATIONS[@]}"

OFFICE_SOFTWARE_SNAP=(
    "notion-desktop" "drawio" "qalculate"
    "surfshark" "varia"
)
sudo snap install "${OFFICE_SOFTWARE_SNAP[@]}"
sudo snap install obsidian --classic

# Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install -y wezterm

# Brave browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser
xdg-settings set default-web-browser brave-browser.desktop

# Flatpaks
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
ADDITIONAL_APPS_FLATPAK=(
    "org.videolan.VLC"
    "org.kde.okular"
    # Electronics - NOTE: might be better to add to a separate hdl script
    "com.github.reds.LogisimEvolution"
    # System
    "net.nokyan.Resources" # - WARN: default in 26.04LTS
    "net.epson.epsonscan2"
    # Project Management
    "org.ghidra_sre.Ghidra"
    "org.jitsi.jitsi-meet"
    "com.rustdesk.RustDesk"
    # Games
    "org.gnome.Chess"
    "org.gnome.Sudoku"
    "app.drey.MultiplicationPuzzle"
    "org.gnome.Mahjongg"
    "org.gnome.Crosswords"
    "org.gnome.Mines"
)
flatpak install --assumeyes flathub "${ADDITIONAL_APPS_FLATPAK[@]}"
xdg-mime default okular_okular.desktop application/pdf

# Install Nix Package manager
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

cd ~/.dotfiles
stow .
cd -

BLOAT_SNAP=(
    "thunderbird"
)
sudo apt-get purge -y "${BLOAT_SNAP[@]}"
sudo snap remove "${BLOAT_SNAP[@]}"

BLOAT_APT=(
    "ed" "vim-common" "nano"
    "transmission-common" "transmission-gtk"
    "rhythmbox" "orca" "info" "yelp"
    "gnome-snapshot" "gnome-logs" "gnome-terminal"
    "gnome-system-monitor" "gnome-power-manager"
    "deja-dup" "seahorse" "shotwell" "evince" "gnome-calculator"
    # WARN: depricated in ubuntu 26.04 LTS to - "showtime"
    "totem"
    # cli tools that clash with nix
    "git" # maybe - curl
)
sudo apt purge -y "${BLOAT_APT[@]}"

echo "The script will exit now, open Wezterm & source \`installer_2.zsh\`"
sleep 2
exit

