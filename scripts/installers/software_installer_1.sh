#!/bin/bash

cd ~/.dotfiles/scripts/installers

echo "Welcome to the *Ubuntu 24.04 LTS* installer :)
This script will automatically reboot the system after it is done"

# GNOME screen lock behaviour
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false

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
    "build-essential" "pkg-config"
    "openjdk-21-jdk" "openjdk-21-jre"
    "nala"
)
sudo apt-get install -y "${ESSENTIALS[@]}" 

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

sudo snap install julia --classic
sudo snap install zig   --classic --beta

rustup toolchain install stable
rustup default stable
cargo install sccache

APPLICATIONS=(
    "gnome-shell-extension-manager"
    "bleachbit"
    # "ubuntu-restricted-extras" "vlc" 
)
sudo apt install -y "${APPLICATIONS[@]}"

# Signal
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

# Open in terminal option nautilus extension
wget https://github.com/Stunkymonkey/nautilus-open-any-terminal/releases/download/0.6.0/nautilus-extension-any-terminal_0.6.0-1_all.deb
sudo apt install -y ./nautilus-extension-any-terminal_0.6.0-1_all.deb
rm -f nautilus-extension-any-terminal_0.6.0-1_all.deb
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal wezterm

# browser
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

# flatpak package manager
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Zsh shell
sudo nala install -y zsh
chsh --shell $(which zsh)

cd ~/.dotfiles
stow .
cd -

mkdir -p $HOME/.config/nixpkgs
echo "{ allowUnfree = true; }" >> ~/.config/nixpkgs/config.nix
zsh -li -c "sh <(curl -L https://nixos.org/nix/install) --daemon"
zsh -li -c "nix-env --install --file cli_pkgs.nix"
zsh -li -c "mise settings set python_compile 1; \ 
mise use --global deno@latest go@latest python@latest python@2.7"

# Flatpaks
ADDITIONAL_APPS_FLATPAK=(
   "org.ghidra_sre.Ghidra"
   # "net.nokyan.Resources"
   "com.usebottles.bottles"
   "se.sjoerd.Graphs"
   "io.github.finefindus.Hieroglyphic"
   "org.gnome.Chess"
   "org.gnome.Sudoku"
   "app.drey.MultiplicationPuzzle"
   "org.gnome.Mahjongg"
   "org.gnome.Crosswords"
   "org.gnome.Mines"
)
flatpak install --assumeyes flathub "${ADDITIONAL_APPS_FLATPAK[@]}"

SNAP_BLOAT=(
    "firefox" "thunderbird"
)
sudo apt-get purge -y "${SNAP_BLOAT[@]}"
sudo snap remove "${SNAP_BLOAT[@]}"
rm -rf ~/.mozilla

SOFTWARE_BLOAT=(
    "transmission-common" "transmission-gtk"
    "rhythmbox" "orca" "info" "yelp"
    "gnome-snapshot" "gnome-logs" 
    "gnome-system-monitor" "gnome-power-manager"
    "deja-dup" "totem" "seahorse" "remmina" "shotwell"
)
sudo nala purge -y "${SOFTWARE_BLOAT[@]}"

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
# GNOME appearance
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
sudo wget -P /usr/share/backgrounds https://ubuntucommunity.s3.us-east-2.amazonaws.com/original/3X/3/2/320af712c96e48da2d5a61f9b1d0ab2c792530ed.jpeg
gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/backgrounds/320af712c96e48da2d5a61f9b1d0ab2c792530ed.jpeg"
gsettings set org.gnome.desktop.background picture-options 'stretched'
# GNOME dash-to-dock config
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 52
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted true
gsettings set org.gnome.shell.extensions.dash-to-dock always-center-icons true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
gsettings set org.gnome.shell favorite-apps "[ 'org.gnome.TextEditor.desktop', 'signal-desktop.desktop', '$(xdg-settings get default-web-browser)', 'org.wezfurlong.wezterm.desktop', 'org.gnome.Nautilus.desktop']"
# GNOME interface config
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.shell.app-switcher current-workspace-only true
# Trash config
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true

echo "The system will reboot now"
sleep 3
reboot
