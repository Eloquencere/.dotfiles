#!/bin/zsh
set -o errexit \
    -o nounset \
    -o pipefail

# NOTE: Learn to setup Jitsi-Meet via apt installation

cd "$(dirname "${(%):-%x}")" # change directory to script location

echo "Welcome to the *Ubuntu 26.04 LTS* installer :)"

sudo nala full-upgrade -y
cd ~/.dotfiles/ && stow . && cd -

sudo nala install -y ttf-mscorefonts-installer fonts-crosextra-carlito fonts-crosextra-caladea # MS fonts for LibreOffice

# Browser
name='brave-browser'
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
sudo nala update
sudo nala install -y $name
xdg-settings set default-web-browser $name.desktop
xdg-mime default $name.desktop x-scheme-handler/mailto
$name &

# Virt-Manager
sudo nala install -y virt-manager qemu-system-x86 qemu-utils libvirt-daemon-system libvirt-clients bridge-utils

# Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
printf '%s\n' \
  'Types: deb' \
  'URIs: https://download.docker.com/linux/ubuntu' \
  "Suites: $(. /etc/os-release && echo ${UBUNTU_CODENAME:-$VERSION_CODENAME})" \
  'Components: stable' \
  "Architectures: $(dpkg --print-architecture)" \
  'Signed-By: /etc/apt/keyrings/docker.asc' \
  | sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null
sudo nala update
sudo nala install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin freerdp3-x11 # try for freerdp3-wayland
sudo usermod -aG docker $USER

# WARN: Look into how to install podman in a similar way

# VSCode
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --yes -o /usr/share/keyrings/microsoft.gpg
printf '%s\n' \
  'Types: deb' \
  'URIs: https://packages.microsoft.com/repos/code' \
  'Suites: stable' \
  'Components: main' \
  "Architectures: $(dpkg --print-architecture)" \
  'Signed-By: /usr/share/keyrings/microsoft.gpg' \
  | sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null
sudo nala update
sudo nala install -y code

# Antigravity
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
printf '%s\n' \
  'Types: deb' \
  'URIs: https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev' \
  'Suites: antigravity-debian' \
  'Components: main' \
  "Architectures: $(dpkg --print-architecture)" \
  'Signed-By: /etc/apt/keyrings/antigravity-repo-key.gpg' \
  | sudo tee /etc/apt/sources.list.d/antigravity.sources > /dev/null
sudo nala update
sudo nala install -y antigravity

# OnlyOffice
curl -fsSL https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE | sudo gpg --dearmor -o /usr/share/keyrings/onlyoffice.gpg
printf '%s\n' \
  'Types: deb' \
  'URIs: https://download.onlyoffice.com/repo/debian' \
  'Suites: squeeze' \
  'Components: main' \
  'Signed-By: /usr/share/keyrings/onlyoffice.gpg' \
  | sudo tee /etc/apt/sources.list.d/onlyoffice.sources > /dev/null
sudo nala update
sudo nala install -y onlyoffice-desktopeditors

# Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
printf '%s\n' \
  'Types: deb' \
  'URIs: https://apt.fury.io/wez/' \
  'Suites: *' \
  'Components: *' \
  "Architectures: $(dpkg --print-architecture)" \
  'Signed-By: /usr/share/keyrings/wezterm-fury.gpg' \
  | sudo tee /etc/apt/sources.list.d/wezterm.sources > /dev/null
sudo nala update
sudo nala install -y wezterm

# Zotero
curl -sL https://raw.githubusercontent.com/retorquere/zotero-pkg/master/install.sh | sudo bash
sudo nala update
sudo nala install -y zotero

# Timeshift
sudo add-apt-repository -y ppa:teejee2008/timeshift
sudo nala update
sudo nala install -y timeshift

APPLICATIONS_APT=(
    "gnome-shell-extension-manager"
    "bleachbit" "gufw"
    "preload" "earlyoom"
    "vlc"
    # Data Recovery
    "testdisk"
)
sudo nala install -y "${APPLICATIONS_APT[@]}"

# Only keep curr & prev versions of a snap pkg 
sudo snap set system refresh.retain=2

OFFICE_SOFTWARE_SNAP=(
    "notion-desktop" # Not available elsewhere
    "surfshark"      # kill switch not in flatpak
)
sudo snap install "${OFFICE_SOFTWARE_SNAP[@]}"
# sudo snap install --channel=6/stable lxd
# sudo snap install --classic workshop

# Games
echo 'ntsync
KERNEL=="ntsync", MODE="0660", TAG+="uaccess"' \
 | sudo tee /etc/modules-load.d/ntsync.conf
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
    # "org.gnome.Mahjongg"
    # "org.gnome.Mines"
    # "org.gnome.Crosswords"
    # "app.drey.MultiplicationPuzzle"
)
flatpak install --assumeyes flathub "${GAMES_FLATPAK[@]}"

# Flatpaks
ADDITIONAL_APPS_FLATPAK=(
    # Office
    "md.obsidian.Obsidian"
    "com.jgraph.drawio.desktop"
    "org.kde.drawy"
    "io.github.Qalculate"
    # System
    "io.github.giantpinkrobots.varia"
    "net.epson.epsonscan2"
    "com.github.tenderowl.frog"
    "io.github.totoshko88.RustConn"
    # Project Management
    "com.rustdesk.RustDesk"
    # "org.jitsi.jitsi-meet"
    # # Coding
    # "org.ghidra_sre.Ghidra"
)
flatpak install --assumeyes flathub "${ADDITIONAL_APPS_FLATPAK[@]}"

# # Consider this over creating a custom keybind for qalculate in dconf.nix
# sudo rm $(which gnome-calculator) /usr/bin/gnome-calculator-original
# sudo ln -sT $(which qalculate) /usr/bin/gnome-calculator

# Installing nix pkg manager
sh <(curl --proto "=https" --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes

echo "This is the end of installer_1, run installer_2 after reboot"
read "?Address all other open windows & Press Enter to reboot..."
sudo reboot now

# # Signal
# wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
# cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
# echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
#   sudo tee /etc/apt/sources.list.d/signal-xenial.list
# sudo apt update && sudo apt install signal-desktop
# rm -rf signal-desktop-keyring.gpg

# # Ghostty - Starship NF icon rendering is weird but, RAM usage is low with zellij
# sudo add-apt-repository --yes ppa:mkasberg/ghostty-ubuntu
# sudo nala update
# sudo nala install -y ghostty

# # Experiment - weird artifacts in the text editor
# echo 'APT::Architecture-Variants "amd64v3";' | sudo tee /etc/apt/apt.conf.d/99amd64v3
# sudo apt update
# sudo apt full-upgrade -y

