#!/bin/zsh

# TODO: Enable variable refresh rate
# TODO: General shell completions under the completions dir aren't working
# TODO: diff completion is good, delta is not showing hidden files

# WARN: even this doesn't work
# Add this to dconf.nix Alternatively, take a call to completely remove the notifier app
# gsettings set com.ubuntu.update-notifier no-show-notifications true

cd "$(dirname "${(%):-%x}")" # change directory to script location

echo "Welcome to the *Ubuntu 26.04 LTS* installer :)"

source sub-scripts/nerdfonts_download.sh
sudo nala install -y ttf-mscorefonts-installer fonts-crosextra-carlito fonts-crosextra-caladea # MS fonts for LibreOffice

# Performance improvement
sudo nala install -y preload earlyoom
sudo systemctl enable preload earlyoom

# Anki
version='26.05'
sudo nala install -y libxcb-xinerama0 libxcb-cursor0 libnss3 libxcb-icccm4 libxcb-keysyms1
wget https://github.com/ankitects/anki/releases/download/$version/anki-launcher-$version-linux.tar.zst
tar xaf anki-launcher-$version-linux.tar.zst
cd anki-launcher-$version-linux/
sudo ./install.sh
anki
cd ..; rm -rf anki-launcher-$version-linux*

# Ulauncher
sudo add-apt-repository -y ppa:agornostal/ulauncher
sudo nala update
sudo nala install -y ulauncher

# Brave Origin browser
name='brave-origin'
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
sudo nala update
sudo nala install -y $name
xdg-settings set default-web-browser $name.desktop
xdg-mime default $name.desktop x-scheme-handler/mailto
$name &

# Ghostty
sudo add-apt-repository --yes ppa:mkasberg/ghostty-ubuntu
sudo nala update
sudo nala install -y ghostty

# Virt-Manager
sudo nala install -y virt-manager qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils qemu-utils
# Try for qemu-system-x86-hwe

# VSCode
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --yes -o /usr/share/keyrings/microsoft.gpg
printf '%s\n' \
  'Types: deb' \
  'URIs: https://packages.microsoft.com/repos/code' \
  'Suites: stable' \
  'Components: main' \
  'Architectures: amd64' \
  'Signed-By: /usr/share/keyrings/microsoft.gpg' \
  | sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null
sudo nala update
sudo nala install code

# Antigravity
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
  sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
  sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null
sudo nala update
sudo nala install antigravity

# KiCAD
version='10.0'
sudo add-apt-repository --yes ppa:kicad/kicad-$version-releases
sudo nala update
sudo nala install -y --install-recommends kicad

# Docker
sudo nala install -y docker.io docker-compose util-linux-extra freerdp3-x11 # try for freerdp3-wayland
sudo usermod -aG docker $USER

APPLICATIONS=(
    "gnome-shell-extension-manager"
    "bleachbit" "timeshift"
    "gufw"
    # Data Recovery
    "testdisk"
)
sudo nala install -y "${APPLICATIONS[@]}"

# Only keep curr & prev versions of a snap pkg 
sudo snap set system refresh.retain=2

OFFICE_SOFTWARE_SNAP=(
    "notion-desktop"   # Not available elsewhere
    # "scrcpy"           # Not available elsewhere # WARN: Not working
)
sudo snap install "${OFFICE_SOFTWARE_SNAP[@]}"

# Games
mkdir -p ~/Games/{switch}
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
echo 'ntsync
KERNEL=="ntsync", MODE="0660", TAG+="uaccess"' | sudo tee /etc/modules-load.d/ntsync.conf

# Flatpaks
ADDITIONAL_APPS_FLATPAK=(
    # Office
    "io.github.Qalculate"
    "com.jgraph.drawio.desktop"
    "org.kde.drawy"
    "md.obsidian.Obsidian"
    # System
    "io.github.diegopvlk.Cine"
    "com.surfshark.Surfshark"
    "io.github.giantpinkrobots.varia"
    "net.epson.epsonscan2"
    "com.github.tenderowl.frog"
    "it.mijorus.gearlever"
    "io.github.totoshko88.RustConn"
    # Project Management
    "com.rustdesk.RustDesk"
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

cd $HOME/.dotfiles/ && stow . && cd -

echo "The system will reboot now to consolidate the installation"
sudo reboot now

# OnlyOffice - If you want some niche MS support
# sudo snap install onlyoffice-desktopeditors

# # Experiment - weird artifacts in the text editor
# echo 'APT::Architecture-Variants "amd64v3";' | sudo tee /etc/apt/apt.conf.d/99amd64v3
# sudo apt update
# sudo apt full-upgrade -y

# # Wezterm - Cursor size & shape changes inside
# curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
# echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
# sudo nala update
# sudo nala install -y wezterm

# # Signal
# wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
# cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
# echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
#   sudo tee /etc/apt/sources.list.d/signal-xenial.list
# sudo apt update && sudo apt install signal-desktop
# rm -rf signal-desktop-keyring.gpg

# # Kodi
# sudo nala install -y kodi

