#!/bin/zsh
set -o errexit \
    -o nounset \
    -o pipefail

# NOTE: Learn to setup Jitsi-Meet via apt installation
# WARN: Need to find out in what stage of the Installation does nautilus insert "Open with Wezterm"
# WARN: Look into flatpak install flathub com.super_productivity.SuperProductivity

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

# Libre office
sudo add-apt-repository ppa:libreoffice/ppa
sudo nala update

# Zotero
curl -sL https://raw.githubusercontent.com/retorquere/zotero-pkg/master/install.sh | sudo bash
sudo nala update
sudo nala install -y zotero

# Timeshift
sudo add-apt-repository -y ppa:teejee2008/timeshift
sudo nala update
sudo nala install -y timeshift

# Mise
sudo add-apt-repository -y ppa:jdxcode/mise
sudo nala update
sudo nala install -y mise

# KiCAD
version='10.0'
sudo add-apt-repository --yes ppa:kicad/kicad-$version-releases
sudo nala update
sudo nala install -y --install-recommends kicad

# Anki
version='26.05'
wget https://github.com/ankitects/anki/releases/latest/download/anki-$version-linux-x86_64.tar.zst
tar xaf anki-$version-linux-x86_64.tar.zst
cd anki-linux/
sudo ./install.sh
anki
cd ..; rm -rf anki-*

APPLICATIONS_APT=(
    "gnome-shell-extension-manager"
    "bleachbit" "gufw"
    "preload" "earlyoom"
    "vlc"
    # Data Recovery
    "testdisk"
)
sudo nala install -y "${APPLICATIONS_APT[@]}"
sudo ufw enable
# GSConnect
mkdir -p $HOME/Transfers/GSConnect
sudo ufw allow 1714:1764/tcp
sudo ufw allow 1714:1764/udp
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf

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
mkdir -p ~/Games/{Ryujinx}
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
    "com.github.flxzt.rnote" # alternative to drawy
    "io.github.Qalculate"
    # System
    "io.github.giantpinkrobots.varia"
    "net.epson.epsonscan2"
    "io.github.totoshko88.RustConn"
    # Project Management
    "com.rustdesk.RustDesk"
    # "org.jitsi.jitsi-meet"
    # # Coding
    # "org.ghidra_sre.Ghidra"
)
flatpak install --assumeyes flathub "${ADDITIONAL_APPS_FLATPAK[@]}"

# AppManager
version='3.7.3'
wget -O appmanager.AppImage "https://github.com/kem-a/AppManager/releases/latest/download/AppManager-$version-anylinux-x86_64.AppImage"
chmod +x ./appmanager.AppImage && ./appmanager.AppImage

# WinBoat
version='0.9.0'
wget -O winboat.AppImage "https://github.com/TibixDev/winboat/releases/latest/download/winboat-$version-x86_64.AppImage"
app-manager install ./winboat.AppImage

# Stirling-PDF
version='2.14.2'
wget -o stirling-pdf.AppImage "https://github.com/pkgforge-dev/Stirling-PDF-AppImage/releases/latest/download/Stirling-PDF-v$version-anylinux-x86_64.AppImage"
app-manager install ./stirling-pdf.AppImage

# LM Studio
wget -O lm-studio.AppImage 'https://lmstudio.ai/download/latest/linux/x64?format=AppImage'
app-manager install ./lm-studio.AppImage

# Installing nix pkg manager
sh <(curl --proto "=https" --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes

# Improving nautilus
xdg-mime default org.gnome.TextEditor.desktop text/markdown
touch ~/Templates/file

mkdir -p $HOME/Projects
echo "file://$HOME/Projects" >> $XDG_CONFIG_HOME/gtk-3.0/bookmarks
# NOTE: might be best to arrange dirs in the bookmarks section
sed -i "\|Music|d" $XDG_CONFIG_HOME/gtk-3.0/bookmarks
rm -f ~/{Music,Public}

# Load wallpaper
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/osselo-Ask_a_friend.jpg'
# # Alternate
# gsettings set org.gnome.desktop.background picture-options 'scaled'
# gsettings set org.gnome.desktop.background picture-uri-dark "file://$DOTFILES_HOME/wallpapers/angkor_watt_gpt.png"

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

