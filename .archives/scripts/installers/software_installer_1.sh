#!/bin/bash

cd ~/.dotfiles/scripts/installers

echo "Welcome to the *Ubuntu 24.04 LTS* installer :)
This script is designed to install as much as possible without human intervention
It will automatically reboot the system after it is done"

# GNOME screen lock behaviour
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false

sudo dpkg --add-architecture i386
sudo sh -c "apt update; apt upgrade -y"

# Installing fonts
sudo apt install -y ttf-mscorefonts-installer fonts-crosextra-carlito fonts-crosextra-caladea # MS fonts for LibreOffice
source nerdfonts_download.sh

ESSENTIALS=(
    "libssl-dev" "liblzma-dev" "libreadline-dev" "libncurses5-dev" "libfuse2t64"
    "sqlite3" "libsqlite3-dev"
    "stow" "curl" "p7zip" "unrar" "zstd"
    "ntfs-3g" "exfat-fuse" "wl-clipboard" "gnuplot"
    "linux-headers-$(uname -r)" "linux-headers-generic" "build-essential" "pkg-config"
    "openjdk-21-jdk" "openjdk-21-jre" "default-jre" "libreoffice-java-common"
    "nala" "aptitude"
    "graphviz"
)
sudo apt-get install -y "${ESSENTIALS[@]}"

export CARGO_HOME="$HOME/.local/share/rust/cargo"
export RUSTUP_HOME="$HOME/.local/share/rust/rustup"
LANGUAGE_COMPILERS=(
    "gcc" "make"
    "gdb" "valgrind" "strace"
    "clang" "lldb"
    "rustup" "perl"
    "python3-pip" "tk-dev"
)
sudo nala install -y "${LANGUAGE_COMPILERS[@]}"

rustup toolchain install stable
rustup default stable
cargo install sccache

sudo snap install julia --classic
sudo snap install zig   --classic --beta

APPLICATIONS=(
    "gnome-shell-extension-manager"
    "bleachbit" "timeshift"
    "kdeconnect"
)
sudo nala install -y "${APPLICATIONS[@]}"

# Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install -y wezterm

# Open in terminal option nautilus extension - WARN: Need to update when new version releases
wget https://github.com/Stunkymonkey/nautilus-open-any-terminal/releases/download/0.6.0/nautilus-extension-any-terminal_0.6.0-1_all.deb
sudo apt install -y ./nautilus-extension-any-terminal_0.6.0-1_all.deb
rm -f nautilus-extension-any-terminal_0.6.0-1_all.deb
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal wezterm

# Brave browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser
xdg-settings set default-web-browser brave-browser.desktop

# Office Software
sudo snap install notion-desktop drawio qalculate
sudo snap install obsidian --classic
# install mcomix or kommiku

sudo snap install surfshark
sudo snap install varia  # WARN: might stop working, use flatpak otherwise

# Anki - WARN: Need to manually update when new version releases
sudo apt install -y libxcb-xinerama0 libxcb-cursor0 libnss3
wget https://github.com/ankitects/anki/releases/download/25.09/anki-launcher-25.09-linux.tar.zst
tar xaf anki-launcher-25.09-linux.tar.zst
cd anki-launcher-25.09-linux
sudo ./install.sh
anki
cd ..; rm -rf anki-launcher-25.09-linux anki-launcher-25.09-linux.tar.zst

# # Signal
# wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
# cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
# echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
#   sudo tee /etc/apt/sources.list.d/signal-xenial.list
# sudo apt update && sudo apt install signal-desktop
# rm -rf signal-desktop-keyring.gpg

# Kicad - WARN: need to update when new version releases
sudo add-apt-repository --yes ppa:kicad/kicad-9.0-releases
sudo apt update
sudo apt install --install-recommends -y kicad

# Zsh shell
sudo nala install -y zsh
chsh --shell $(which zsh)

cd ~/.dotfiles
stow .
cd -

zsh -li -c "sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon"
CLI_TOOLS=(
    "nixpkgs#starship" "nixpkgs#fzf" "nixpkgs#atuin" "nixpkgs#zoxide" "nixpkgs#mise"
    "nixpkgs#eza" "nixpkgs#fd" "nixpkgs#bat" "nixpkgs#ripgrep" "nixpkgs#repgrep" "nixpkgs#duf" "nixpkgs#delta"
    "nixpkgs#croc" "nixpkgs#fastfetch"

    "nixpkgs#dos2unix" "nixpkgs#btop" "nixpkgs#yazi"
    # "nixpkgs#jq" # jqp yq
    "nixpkgs#neovim" "nixpkgs#zellij" "nixpkgs#mprocs"
    "nixpkgs#conan" "nixpkgs#scriptisto" "nixpkgs#tio"
    "nixpkgs#gh" "nixpkgs#lazygit"
    "nixpkgs#podman" # look into Podman TUI
    # "nixpkgs#ollama"
    "nixpkgs#tlrc" "nixpkgs#cheat"
    "nixpkgs#typst" "nixpkgs#natural-docs" "nixpkgs#doxygen"
)
# WARN: might be a good idea to try to replace 'install' with 'add'
zsh -li -c "export NIXPKGS_ALLOW_UNFREE=1; \
nix profile install --impure $(printf '%s ' "${CLI_TOOLS[@]}"); \
sudo update-alternatives --install /usr/bin/nvim editor \$(which nvim) 100"
zsh -li -c "mise install go@latest node@latest deno@latest python@latest python@2.7"

# Flatpaks
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
ADDITIONAL_APPS_FLATPAK=(
    "org.videolan.VLC"
    "org.kde.okular"
    # Electronics
    "com.github.reds.LogisimEvolution"
    # System
    "net.nokyan.Resources" # - WARN: default in 26.04LTS
    "net.epson.epsonscan2"
    # Backup
    "org.gnome.World.PikaBackup"
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

# Setting a reminder at 21:30 every alternate day to backup progress
(crontab -l ; echo "30 21 */2 * * DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus notify-send 'Backup your current progress with PIKA BACKUP'") | crontab -

SNAP_BLOAT=(
    "thunderbird"
)
sudo apt-get purge -y "${SNAP_BLOAT[@]}"
sudo snap remove "${SNAP_BLOAT[@]}"

SOFTWARE_BLOAT=(
    "ed" "vim-common" "nano"
    "transmission-common" "transmission-gtk"
    "rhythmbox" "orca" "info" "yelp"
    "gnome-snapshot" "gnome-logs"
    "gnome-system-monitor" "gnome-power-manager"
    "deja-dup" "seahorse" "shotwell" "evince" "gnome-calculator"
    # WARN: depricated in ubuntu 26.04 LTS to - "showtime"
    "totem"
)
sudo nala purge -y "${SOFTWARE_BLOAT[@]}"


# GNOME TextEditor config
gsettings set org.gnome.TextEditor style-scheme 'classic-dark'
gsettings set org.gnome.TextEditor restore-session false
gsettings set org.gnome.TextEditor show-line-numbers true
gsettings set org.gnome.TextEditor highlight-current-line true
gsettings set org.gnome.TextEditor highlight-matching-brackets true
gsettings set org.gnome.TextEditor tab-width 4
# Nautilus config
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'small-plus'
# GNOME desktop config
gsettings set org.gnome.shell.extensions.ding show-home false
gsettings set org.gnome.shell.extensions.ding start-corner 'top-left'
gsettings set org.gnome.mutter center-new-windows true
# GNOME appearance config
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface text-scaling-factor 1.20
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-blue'
# sudo wget -P /usr/share/backgrounds https://ubuntucommunity.s3.us-east-2.amazonaws.com/original/3X/4/b/4bf6d235b96c6c5027be79e43ebd460a0bf25e07.jpeg
sudo wget -P /usr/share/backgrounds https://ubuntucommunity.s3.us-east-2.amazonaws.com/original/3X/3/2/320af712c96e48da2d5a61f9b1d0ab2c792530ed.jpeg
gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/backgrounds/320af712c96e48da2d5a61f9b1d0ab2c792530ed.jpeg"
gsettings set org.gnome.desktop.background picture-options 'stretched'
# Night Light config
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4039
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0.0 # Always enabled
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 0.0
# GNOME dock config
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 50
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted true
gsettings set org.gnome.shell.extensions.dash-to-dock always-center-icons true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
gsettings set org.gnome.shell favorite-apps "['org.gnome.TextEditor.desktop', 'notion-desktop_notion-desktop.desktop', 'obsidian_obsidian.desktop', 'brave-browser.desktop', 'org.wezfurlong.wezterm.desktop', 'org.gnome.Nautilus.desktop']"
# GNOME interface config
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.shell.app-switcher current-workspace-only true

echo "The system will reboot now"
sleep 2
sudo reboot now

