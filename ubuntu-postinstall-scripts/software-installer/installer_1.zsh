#!/bin/zsh

# TODO: General shell completions under the completions dir aren't working
# TODO: diff completion is good, delta is not showing hidden files

cd "$(dirname "${(%):-%x}")" # change directory to script location

echo "Welcome to the *Ubuntu 26.04 LTS* installer :)"

# # WARN: Known Issue - fzf tab not working as intended - https://github.com/Aloxaf/fzf-tab/issues/549
# sudo apt-get install -y coreutils-from-gnu coreutils-from-uutils- --allow-remove-essential

source sub-scripts/nerdfonts_download.sh
sudo nala install -y ttf-mscorefonts-installer fonts-crosextra-carlito fonts-crosextra-caladea # MS fonts for LibreOffice

# Performance improvement
sudo nala install -y preload earlyoom
sudo systemctl enable preload earlyoom

# Anki
version='25.09'
sudo nala install -y libxcb-xinerama0 libxcb-cursor0 libnss3 libxcb-icccm4 libxcb-keysyms1
wget https://github.com/ankitects/anki/releases/download/$version/anki-launcher-$version-linux.tar.zst
tar xaf anki-launcher-$version-linux.tar.zst
cd anki-launcher-$version-linux
sudo ./install.sh
anki # WARN: Not sure if this thing will close the terminal after completing
cd ..; rm -rf anki-launcher-$version-linux*

# Brave browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo nala update
sudo nala install -y brave-browser
xdg-settings set default-web-browser brave-browser.desktop
xdg-mime default brave-browser.desktop x-scheme-handler/mailto
brave-browser &

# Ghostty
sudo add-apt-repository --yes ppa:mkasberg/ghostty-ubuntu
sudo nala update
sudo nala install -y ghostty

# Virt-Manager
sudo nala install -y virt-manager qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils qemu-utils
# Try for qemu-system-x86-hwe

# KiCAD
sudo add-apt-repository --yes ppa:kicad/kicad-10.0-releases
sudo nala update
sudo nala install -y --install-recommends kicad

# Docker - Specifically for winboat
sudo nala install -y docker.io docker-compose util-linux-extra freerdp3-x11 # try for freerdp3-wayland
sudo usermod -aG docker $USER

APPLICATIONS=(
    "gnome-shell-extension-manager"
    "bleachbit" "timeshift"
    "gufw"
)
sudo nala install -y "${APPLICATIONS[@]}"

# Only keep curr & prev versions of a snap pkg 
sudo snap set system refresh.retain=2

OFFICE_SOFTWARE_SNAP=(
    "notion-desktop" # Not available anywhere else
    "lemonade-desktop" # Not available anywhere else
)
sudo snap install "${OFFICE_SOFTWARE_SNAP[@]}"
sudo snap install obsidian --classic # In flatpak, write errors on mounted cloud drives

# Games
mkdir -p ~/Games/{windows,switch}
sudo nala install -y steam
GAMES_FLATPAK=(
    "com.discordapp.Discord"
    "com.heroicgameslauncher.hgl"
    "io.github.ryubing.Ryujinx"
    # "com.parsecgaming.parsec"
    # # Optional
    # "org.gnome.Chess"
    # "org.gnome.Sudoku"
    # "app.drey.MultiplicationPuzzle"
    # "org.gnome.Mahjongg"
    # "org.gnome.Crosswords"
    # "org.gnome.Mines"
)
flatpak install --assumeyes flathub "${GAMES_FLATPAK[@]}"

# Flatpaks
ADDITIONAL_APPS_FLATPAK=(
    # Office
    "io.github.Qalculate"
    "com.jgraph.drawio.desktop"
    # System
    "org.videolan.VLC"
    "com.surfshark.Surfshark"
    "io.github.giantpinkrobots.varia"
    "net.epson.epsonscan2"
    "com.github.tenderowl.frog"
    "it.mijorus.gearlever"
    "io.github.totoshko88.RustConn"
    # Project Management
    "com.rustdesk.RustDesk"
    # "io.github.alainm23.planify"
    # "org.jitsi.jitsi-meet"
    # "org.ghidra_sre.Ghidra"
)
flatpak install --assumeyes flathub "${ADDITIONAL_APPS_FLATPAK[@]}"

# fix title bar color - (draw.io & Heroic)
flatpak install --assumeyes flathub org.gtk.Gtk3theme.Yaru-dark
flatpak override --user --env=GTK_THEME=Yaru-dark

# NOTE: following will take effect after (shell) restart

# Installing nix pkg manager
sh <(curl --proto "=https" --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes

cd $HOME/.dotfiles && stow . && cd -

echo "The system will reboot now to consolidate the installation"
sudo reboot now

# # Experiment - weird artifacts in the text editor
# echo 'APT::Architecture-Variants "amd64v3";' | sudo tee /etc/apt/apt.conf.d/99amd64v3
# sudo apt update
# sudo apt full-upgrade -y

# # Only enable if /dev/ntsync is missing
# echo 'ntsync
# KERNEL=="ntsync", MODE="0660", TAG+="uaccess"' | sudo tee /etc/modules-load.d/ntsync.conf

# # Wezterm - Cursor size & shape changes inside
# curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
# echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
# sudo nala update
# sudo nala install -y wezterm

# # VSCode
# wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
# sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
# sudo apt install -y apt-transport-https && sudo apt update
# sudo apt install code
# rm -f packages.microsoft.gpg

# # Signal
# wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
# cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
# echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
#   sudo tee /etc/apt/sources.list.d/signal-xenial.list
# sudo apt update && sudo apt install signal-desktop
# rm -rf signal-desktop-keyring.gpg

