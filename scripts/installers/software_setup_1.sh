#! /bin/bash

gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

echo "Welcome to the installer, this will be part 1 of installing all necessary tools for development
This script will automatically reboot the system after it is done"
sleep 5

mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

sudo pacman -Syu --noconfirm

# Uninstall bloat
BLOAT_PKGS_PACMAN=(
  "vim" "htop" "nano"
  "epiphany" "gnome-music" "gnome-calendar"
  "gnome-contacts" "sushi" "gnome-weather" "gnome-tour"
  "totem" "gnome-maps" "gnome-logs" "gnome-calculator" "orca"
)
sudo pacman -Rns --noconfirm "${BLOAT_PKGS_PACMAN[@]}"

echo "Do you have an amd or intel CPU?"
echo -n "a -> amd & i -> intel: "
read cpu_name
declare -A UCODE_PACMAN=(
	[a]="amd-ucode"
	[i]="intel-ucode"
)
sudo pacman -S --needed --noconfirm "${UCODE_PACMAN[${cpu_name}]}"

# System config
sudo sed -i "s/^\(GRUB_DEFAULT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT_STYLE=\).*/\1hidden/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo sed -i "s/^#\(Color.*\)/\1\nILoveCandy/g" /etc/pacman.conf
sudo sed -i "s/^#\(ParallelDownloads .*\)/\1/g" /etc/pacman.conf
sudo sed -i "/^#\[multilib\]/{s/^#\(.*\)/\1/g; n; s/^#\(.*\)/\1/g;}" /etc/pacman.conf
sudo pacman -Sy

# Primary initialisations
BASIC_PKGS_PACMAN=(
  "base-devel" 
  "zsh" "neovim"
  "rustup"
)
export CARGO_HOME="$HOME/.local/share/rust/.cargo"
export RUSTUP_HOME="$HOME/.local/share/rust/.rustup"
sudo pacman -S --needed --noconfirm "${BASIC_PKGS_PACMAN[@]}"
chsh -s $(which zsh)

# rust initialisations
rustup toolchain install stable
rustup default stable
cargo install sccache
export RUSTC_WRAPPER="$CARGO_HOME/bin/sccache"

# Installing external package managers paru(AUR), flatpak(flathub)
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru/
sudo pacman -S --needed --noconfirm flatpak

# Language compilers and related packages
LANG_COMPILER_PKGS_PACMAN=(
  "jdk21-openjdk" "gdb" "valgrind" "strace" "ghidra"
  "clang" "lldb"
  "perl" "go" "python"
  "zig" "julia" "ghc"
)
sudo pacman -S --needed --noconfirm "${LANG_COMPILER_PKGS_PACMAN[@]}"
LANG_COMPILERS_PKGS_PARU=(
  "mise-bin"
  "conan"
  # "scriptisto"
)
export CONAN_HOME="$HOME/.local/share/conan"
paru -S --noconfirm "${LANG_COMPILERS_PKGS_PARU[@]}"

# Basic software
UTIL_PKGS_PACMAN=(
  "ttf-jetbrains-mono-nerd"
  "arch-wiki-docs" "arch-wiki-lite"
  "p7zip" "unrar" "exfat-utils" "ntfs-3g"
  "libreoffice-fresh" "vlc"
  "fastfetch" "btop" # benchmarkers
  "ufw" # firewall
)
sudo pacman -S --noconfirm "${UTIL_PKGS_PACMAN[@]}"
sudo systemctl enable ufw --now
UTIL_PKGS_PARU=(
  "nautilus-open-any-terminal"
  "preload" # to open up software faster
  # "auto-cpufreq"
)
paru -S --noconfirm "${UTIL_PKGS_PARU[@]}"
sudo systemctl enable preload --now
# sudo systemctl enable auto-cpufreq --now

# Command line tools
CLI_PKGS_PACMAN=(
  "man-db"
  "github-cli" "tree"
  "fzf" "zoxide" "eza" "bat" "fd" "ripgrep" "jq" "yq" "less"
  "yazi" "gdu" "duf" "dust" "git-delta" "lazygit" "procs"
  "stow" "openbsd-netcat" "dos2unix"
)
sudo pacman -S --noconfirm "${CLI_PKGS_PACMAN[@]}"
CLI_PKGS_PARU=(
  "speedtest-rs-bin"
  "jqp-bin"
  "tlrc-bin" # "cheat"
  "kanata-bin"
  "tio"
  "pipes.sh"
)
paru -S --noconfirm "${CLI_PKGS_PARU[@]}"

# Kanata config
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER
sudo sh -c "echo '# Kanata
KERNEL==uinput, MODE=0660, GROUP=uinput, OPTIONS+=static_node=uinput' >> /etc/udev/rules.d/99-input.rules"
sudo udevadm control --reload && udevadm trigger --verbose --sysname-match=uniput
sudo ln -s $HOME/.config/kanata /etc/
sudo sh -c "echo '[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Type=simple
ExecStartPre=/sbin/modprobe uinput
ExecStart=$(which kanata) --cfg /etc/kanata/config.kbd
Restart=no

[Install]
WantedBy=default.target' > /lib/systemd/system/kanata.service"
sudo systemctl enable kanata --now

# usbip
sudo pacman -S --noconfirm usbip
sudo sh -c " echo '# usbip
usbip-core
vhci-hcd' > /etc/modules-load.d/usbip.conf"

# Terminal Emulator tools
TERMINAL_EMULATOR_PKGS_PACMAN=(
  "alacritty" "starship" "atuin"
  "tmux" "tmuxp"
)
sudo pacman -S --noconfirm "${TERMINAL_EMULATOR_PKGS_PACMAN[@]}"

PROCESS_MANAGEMENT_TOOLS_PACMAN=(
    "docker"
)
# sudo pacman -S --noconfirm "${PROCESS_MANAGEMENT_TOOLS_PACMAN[@]}"
PROCESS_MANAGEMENT_TOOLS_PARU=(
    "mprocs-bin"
)
# paru -S --noconfirm "${PROCESS_MANAGEMENT_TOOLS_PARU[@]}"

# Project Management Tools
PROJECT_MANAGEMENT_TOOLS_PACMAN=(
   "signal-desktop" "croc"
   "doxygen"
)
sudo pacman -S --noconfirm "${PROJECT_MANAGEMENT_TOOLS_PACMAN[@]}"
PROJECT_MANAGEMENT_TOOLS_PARU=(
    "jitsi-meet-desktop-bin" # project management tools
    "naturaldocs2"
)
paru -S --noconfirm "${PROJECT_MANAGEMENT_TOOLS_PARU[@]}"
mkdir ~/croc-inbox ~/Tools
sed -i "1i\file://$HOME/croc-inbox" ~/.config/gtk-3.0/bookmarks
sed -i "1i\file://$HOME/Tools" ~/.config/gtk-3.0/bookmarks

# Cool tools
ADDITIONAL_TOOLS_FLATPAK=(
   "ExtensionManager"
   "bottles"
   "io.github.Qalculate"
   "se.sjoerd.Graphs"
   "io.github.diegoivanme.flowtime"
   "io.github.finefindus.Hieroglyphic"
   "org.gnome.gitlab.somas.Apostrophe"
   "org.gnome.Crosswords"
   "org.gnome.Sudoku"
   "org.gnome.Chess"
   "io.github.nokse22.ultimate-tic-tac-toe"
   "info.febvre.Komikku"
   # "com.github.neithern.g4music"
)
flatpak install --assumeyes flathub "${ADDITIONAL_TOOLS_FLATPAK[@]}"

# GNOME nautilus-open-any-terminal config
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak system
# GNOME TextEditor config
gsettings set org.gnome.TextEditor restore-session false
gsettings set org.gnome.TextEditor style-scheme 'classic-dark'
# Gnome window config
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
# GNOME interface config
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font'

cd ~/Documents
rm -rf install_script_temp_folder

# Initialising all dotfiles
cd ~/.dotfiles
stow .
cd -

echo "The system will reboot now"
sleep 10
reboot

