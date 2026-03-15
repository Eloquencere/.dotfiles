#!/bin/zsh

# NOTE: Use pushd & popd instead
cd "$(dirname "${(%):-%x}")" # change directory to script location

echo "Welcome to the *Ubuntu 26.04 LTS* installer :)"

# TODO: delta/diff completion is still broken

# WARN: ubuntu support for x86-64-v3 range
# WARN: check if ntsync support is there

source sub-scripts/nerdfonts_download.sh
sudo nala install -y ttf-mscorefonts-installer fonts-crosextra-carlito fonts-crosextra-caladea # MS fonts for LibreOffice

# Performance improvement software
sudo nala install -y preload earlyoom
sudo systemctl enable preload earlyoom

# Brave browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo nala update
sudo nala install -y brave-browser
xdg-settings set default-web-browser brave-browser.desktop

# Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo nala update
sudo nala install -y wezterm

# Virt-Manager
cd ~/Downloads
sudo nala install -y qemu-kvm bridge-utils virt-manager libosinfo-bin
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.271-1/virtio-win.iso
wget https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe
cd -

# KiCAD
sudo add-apt-repository --yes ppa:kicad/kicad-9.0-releases
sudo nala update
sudo nala install --install-recommends -y kicad

APPLICATIONS=(
    "gnome-shell-extension-manager"
    "bleachbit" "timeshift"
    "kdeconnect" "gufw"
)
sudo nala install -y "${APPLICATIONS[@]}"

# Only keep 2 versions of a snap pkg
sudo snap set system refresh.retain=2

OFFICE_SOFTWARE_SNAP=(
    "notion-desktop" # Not available anywhere else
    "drawio"         # In flatpak, window bezzels are white & don't fit the screen's aspect ratio
)
sudo snap install "${OFFICE_SOFTWARE_SNAP[@]}"
sudo snap install obsidian --classic # In flatpak, write errors on mounted cloud drives

# Games
mkdir ~/Games
sudo nala install steam --install-suggests -y
GAMES_FLATPAK=(
    "com.discordapp.Discord"
    "com.heroicgameslauncher.hgl"
    # "com.parsecgaming.parsec"
)
flatpak install --assumeyes flathub "${GAMES_FLATPAK[@]}"

# Flatpaks
ADDITIONAL_APPS_FLATPAK=(
    "io.github.Qalculate"
    "it.mijorus.gearlever" # appimage management
    "org.kde.okular"
    "com.surfshark.Surfshark"
    "org.videolan.VLC"
    # "com.github.tenderowl.frog"
    # System
    "net.nokyan.Resources" # - WARN: default in 26.04LTS
    "net.epson.epsonscan2"
    # Project Management
    "io.github.giantpinkrobots.varia"
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

# NOTE: following will take effect after (shell) restart

# Installing nix pkg manager
sh <(curl --proto "=https" --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes

stow --dir="$HOME/.dotfiles" .

echo "The system will reboot now to consolidate the installation"
sudo reboot now

