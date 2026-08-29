#!/bin/zsh

cd "$(dirname "${(%):-%x}")" # change directory to script location
sudo -v

echo "Welcome to the *Ubuntu 26.04 LTS* installer :)"

# To prevent the screen from dimming
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.desktop.session idle-delay 0

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

# Zotero
curl -sL https://raw.githubusercontent.com/retorquere/zotero-pkg/master/install.sh | sudo bash
sudo nala update
sudo nala install -y zotero

# Mise
sudo add-apt-repository -y ppa:jdxcode/mise
sudo nala update
sudo nala install -y mise

sudo add-apt-repository -y ppa:libreoffice/ppa
sudo add-apt-repository -y ppa:git-core/ppa
sudo nala update

APPLICATIONS_APT=(
    "gdb" "valgrind" "strace"
    "gnome-shell-extension-manager" "bleachbit"
    "ffmpeg"
    # Virtual machine
    "virt-manager" "qemu-system-x86" "qemu-utils" "libvirt-daemon-system" "libvirt-clients" "bridge-utils"
    # Data Recovery
    "testdisk" "timeshift"
)
sudo nala install -y "${APPLICATIONS_APT[@]}"

# Perf Improvement
sudo nala install -y preload earlyoom
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf

sudo nala install -y gufw
sudo ufw enable
# GSConnect
sudo ufw allow 1714:1764/tcp
sudo ufw allow 1714:1764/udp
mkdir -p $HOME/Transfers/GSConnect

# Only keep curr & prev versions of a snap pkg 
sudo snap set system refresh.retain=2

OFFICE_SOFTWARE_SNAP=(
    "notion-desktop" # Not available elsewhere
    "surfshark"      # kill switch not in flatpak
    "drawio"         # flatpak is not official
)
sudo snap install "${OFFICE_SOFTWARE_SNAP[@]}"
# sudo snap install --channel=6/stable lxd
# sudo snap install --classic workshop

# Games
echo 'ntsync' | sudo tee /etc/modules-load.d/ntsync.conf
echo 'KERNEL=="ntsync", MODE="0660", TAG+="uaccess"' \
  | sudo tee /etc/udev/rules.d/99-ntsync.rules
mkdir -p ~/Games/Ryujinx
sudo nala install -y steam gamemode
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
    "org.kde.drawy" # rnote dark mode not working
    "io.github.Qalculate"
    "org.videolan.VLC"
    "org.gnome.gitlab.somas.Apostrophe"
    # System
    "io.github.mhogomchungu.media-downloader"
    "net.epson.epsonscan2"
    # "io.github.totoshko88.RustConn"
    # Project Management
    "com.rustdesk.RustDesk"
    # "org.jitsi.jitsi-meet" # Jitsi-client
    # # Coding
    # "org.ghidra_sre.Ghidra"
)
flatpak install --assumeyes flathub "${ADDITIONAL_APPS_FLATPAK[@]}"

# cpanminus pkg manager for perl
sudo sh -c 'curl -fsSL https://cpanmin.us | perl - App::cpanminus'

# Nixpkg manager
sh <(curl --proto "=https" --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes

# Gradia - GNOME Extension
git clone https://github.com/AlexanderVanhee/gradia-capture.git && \
cd gradia-capture && \
./build.sh -i
cd -
rm -rf gradia-capture
flatpak install --assumeyes flathub be.alexandervanhee.gradia

# Improving nautilus
xdg-mime default org.gnome.TextEditor.desktop text/markdown
touch ~/Templates/file

echo "This is the end of installer_1, run installer_2 after reboot"
sleep 2
sudo reboot now

# # Antigravity
# curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
# printf '%s\n' \
#   'Types: deb' \
#   'URIs: https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev' \
#   'Suites: antigravity-debian' \
#   'Components: main' \
#   "Architectures: $(dpkg --print-architecture)" \
#   'Signed-By: /etc/apt/keyrings/antigravity-repo-key.gpg' \
#   | sudo tee /etc/apt/sources.list.d/antigravity.sources > /dev/null
# sudo nala update
# sudo nala install -y antigravity

# # Signal
# wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
# cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
# echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
#   sudo tee /etc/apt/sources.list.d/signal-xenial.list
# sudo apt update && sudo apt install signal-desktop
# rm -rf signal-desktop-keyring.gpg

# # Docker desktop
# wget -O docker-desktop.deb 'https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64'
# sudo nala install -y ./docker-desktop.deb
# rm -f ./docker-desktop.deb

# # Ghostty - Starship NF icon rendering is weird but, RAM usage is low with zellij
# sudo add-apt-repository --yes ppa:mkasberg/ghostty-ubuntu
# sudo nala update
# sudo nala install -y ghostty

# No release file (On 26.04)
# sudo add-apt-repository -y ppa:ubuntuhandbook1/vlc
# sudo add-apt-repository -y ppa:teejee2008/timeshift
# sudo add-apt-repository -y ppa:ubuntuhandbook1/transmission

# # Experiment - weird artifacts in the text editor
# echo 'APT::Architecture-Variants "amd64v3";' | sudo tee /etc/apt/apt.conf.d/99amd64v3
# sudo apt update
# sudo apt full-upgrade -y

