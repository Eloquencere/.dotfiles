echo "Welcome to the installer, this will be part 1 of installing all necessary tools for development
This script will automatically reboot the system after it is done"
sleep 10

mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Temporary setup for zsh shell
BASIC_PKGS_PACMAN=(
  "base-devel" 
  "zsh" "neovim"
)
sudo pacman -S --needed --noconfirm "${BASIC_PKGS_PACMAN[@]}"
chsh -s $(which zsh)
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

# Language compilers and related packages
LANG_COMPILER_PKGS_PACMAN=(
  "perl" "go" "python"
  "clang" "lldb"
  "rustup"
  "python-pip" "tk"
  "ghc" "zig"
)
LANG_COMPILERS_PKGS_PARU=(
  "conan"
  "scriptisto" # script in any compiled language
)
sudo pacman -S gdb valgrind strace ghidra
export CARGO_HOME="$HOME/.local/share/rust/.cargo"
export RUSTUP_HOME="$HOME/.local/share/rust/.rustup"
export CONAN_HOME="$HOME/.local/share/conan"
sudo pacman -S --needed --noconfirm "${LANG_COMPILER_PKGS_PACMAN[@]}"
rustup toolchain install stable
rustup default stable

cargo install sccache
export RUSTC_WRAPPER="$CARGO_HOME/bin/sccache"
QUALITY_OF_LIFE_CRATES=(
  "cargo-binstall" "cargo-expand"
  "irust" "bacon"
  # tokio rayon
)
cargo install "${QUALITY_OF_LIFE_CRATES[@]}"
QUALITY_OF_LIFE_CRATES_BIN=(
  "mise" # language version control
)
cargo binstall "${QUALITY_OF_LIFE_CRATES_BIN[@]}"

# Installing external package managers paru(AUR), flatpak(flathub)
sudo pacman -Syu --noconfirm
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru/
sudo pacman -S --noconfirm flatpak

paru -S --noconfirm "${LANG_COMPILERS_PKGS_PARU[@]}"

# Basic software
UTIL_PKGS_PACMAN=(
  "ttf-jetbrains-mono-nerd"
  "arch-wiki-docs" "arch-wiki-lite"
  "p7zip" "unrar" "exfat-utils" "ntfs-3g"
  "libreoffice-fresh" "vlc"
  "fastfetch" "btop" # benchmarkers
  "stow" "openbsd-netcat"
  "ufw" # firewall
  "dos2unix"
)
UTIL_PKGS_PARU=(
  "speedtest-rs-bin"
  "nautilus-open-any-terminal"
)
sudo pacman -S --noconfirm "${UTIL_PKGS_PACMAN[@]}"
sudo systemctl enable ufw --now
paru -S --noconfirm "${UTIL_PKGS_PARU[@]}"

# Others
QOF_PKGS_PARU=(
  "preload" # to open up software faster
  # "auto-cpufreq"
)
paru -S --noconfirm "${QOF_PKGS_PARU[@]}"
sudo systemctl enable preload --now
# sudo systemctl enable auto-cpufreq --now

# Install extension manager
flatpak install --assumeyes ExtensionManager

# Browser
echo "Would you like to install brave or google chrome?"
echo -n "b -> brave & gc -> google chrome: "
read browser_choice
declare -A BROWSER_PARU=(
	[b]="brave-bin"
	[gc]="google-chrome"
)
paru -S --noconfirm "${BROWSER_PARU[${browser_choice}]}"

# Command line tools
CLI_PKGS_PACMAN=(
  "github-cli" "tree"
  "fzf" "zoxide" "eza" "bat" "fd" "ripgrep" "jq" "yq" "less"
  "yazi" "gdu" "duf" "dust" "git-delta" "lazygit" "procs"
  "man-db"
  "glow"
  "croc" # alternative to warp
)
CLI_PKGS_PARU=(
  # "jqp-bin"
  "tlrc-bin" "cheat"
  "kanata-bin" "mprocs-bin"
  "tio"
  "pipes.sh"
)
sudo pacman -S --noconfirm "${CLI_PKGS_PACMAN[@]}"
paru -S --noconfirm "${CLI_PKGS_PARU[@]}"
mkdir ~/croc-inbox

#Kanata
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

# Terminal Emulator tools
TERMINAL_EMULATOR_PKGS_PACMAN=(
  "alacritty" "starship" "atuin"
  "tmux" "tmuxp"
)
sudo pacman -S --noconfirm "${TERMINAL_EMULATOR_PKGS_PACMAN[@]}"

# Remote machine tools
REMOTE_MACHINE_PKGS_PACMAN=(
  "usbip"
)
REMOTE_MACHINE_PKGS_PARU=(
  "nomachine" "rustdesk-bin" "parsec-bin"
)
sudo pacman -S --noconfirm "${REMOTE_MACHINE_PKGS_PACMAN[@]}"
sudo sh -c " echo '# USBIP
usbip-core
vhci-hcd' > /etc/modules-load.d/usbip.conf"
# paru -S --noconfirm "${REMOTE_MACHINE_PKGS_PARU[@]}"

# Initialising all dot files
cd ~/.dotfiles
stow .
cd -

# Gnome window config
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
# GNOME nautilus-open-any-terminal config
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak system
# GNOME TextEditor config
gsettings set org.gnome.TextEditor restore-session false
gsettings set org.gnome.TextEditor style-scheme 'classic-dark'
# GNOME interface config
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font'

cd ~/Documents
rm -rf install_script_temp_folder

echo "The system will reboot now"

sleep 10
reboot
