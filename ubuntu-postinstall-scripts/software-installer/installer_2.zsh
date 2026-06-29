#!/bin/zsh
set -o errexit \
    -o nounset \
    -o pipefail

cd "$(dirname "${(%):-%x}")" # change directory to script location

echo "Click on 'Move to App Menu'"

# WinBoat
version='0.9.0'
wget -O winboat.AppImage "https://github.com/TibixDev/winboat/releases/latest/download/winboat-$version-x86_64.AppImage"
flatpak run it.mijorus.gearlever ./winboat.AppImage

# Handy - AI transcribing
version='0.8.3'
wget -O handy.AppImage "https://github.com/cjpais/Handy/releases/latest/download/Handy_${version}_amd64.AppImage"
flatpak run it.mijorus.gearlever ./handy.AppImage

# LM Studio
wget -O lm-studio.AppImage 'https://lmstudio.ai/download/latest/linux/x64?format=AppImage'
flatpak run it.mijorus.gearlever ./lm-studio.AppImage

# GUI setup
open .gui_instructions.txt

# Install Stirling pdf
cd ~/.config/stirling-pdf/
docker compose pull && docker compose up -d --build
cd -

nix profile add 'nixpkgs#home-manager'
home-manager switch

# Kanata setup - System level
nix profile add 'nixpkgs#kanata'
sudo groupadd uinput
sudo usermod -aG input,uinput $USER
echo '# Kanata
KERNEL==uinput, MODE=0660, GROUP=uinput, OPTIONS+=static_node=uinput' \
| sudo tee /etc/udev/rules.d/99-kanata.rules
echo "[Unit]
Description=Kanata keyboard remapper

[Service]
Type=simple
ExecStartPre=/sbin/modprobe uinput
ExecStart=$(which kanata) --cfg $XDG_CONFIG_HOME/kanata/config.kbd
Restart=no

[Install]
WantedBy=default.target" \
| sudo tee /etc/systemd/system/kanata.service
sudo systemctl enable kanata

mise trust
mise install
# WARN: don't have access to rustup here
# mise doctor
# mise reshim

# cpanm package manager for perl
echo $'Say "\033[1;33myes\033[0m" to the first & "\033[1;33msudo\033[0m" to the next question'
cpan App::cpanminus

# # Hermes WARN: Address all the action points in Agent Insertion
# curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
# hermes update

# GSConnect
mkdir -p ~/Transfers/GSConnect
sudo ufw allow 1714:1764/tcp
sudo ufw allow 1714:1764/udp

# Load wallpaper
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/osselo-Ask_a_friend.jpg'
# # Alternate
# gsettings set org.gnome.desktop.background picture-options 'scaled'
# gsettings set org.gnome.desktop.background picture-uri-dark "file://$DOTFILES_HOME/wallpapers/angkor_watt_gpt.png"

xdg-mime default org.gnome.TextEditor.desktop text/markdown

# NOTE: might be best to arrange dirs in the bookmarks section

# NOTE: Will be default in the future
mkdir -p $HOME/Projects
echo "file://$HOME/Projects" >> $XDG_CONFIG_HOME/gtk-3.0/bookmarks

mkdir -p $ZDOTDIR/personal
echo -n "Enter the ID granted by your admin to register with your team via croc: "
read croc_id
echo "# Croc
export CROC_SELF_TRANSFER_ID=$croc_id" >> $ZDOTDIR/personal/zprofile.zsh
echo "Move a copy of the collaborators database given by your admin to the zsh home directory"
mkdir -p ~/Transfers/croc
echo "file://$HOME/Transfers" >> $XDG_CONFIG_HOME/gtk-3.0/bookmarks

sed -i "\|Music|d" $XDG_CONFIG_HOME/gtk-3.0/bookmarks

mkdir -p $XDG_CONFIG_HOME/git
touch $XDG_CONFIG_HOME/git/config
git config --file $XDG_CONFIG_HOME/git/config init.defaultBranch main
git config --global core.whitespace error
git config --global core.preloadindex true
git config --global core.pager delta
git config --global delta.navigate true
git config --global delta.dark true
git config --global delta.side-by-side true
git config --global interactive.diffFilter 'delta --color-only'
git config --global diff.colorMoved default
git config --global merge.conflictstyle diff3
echo -n "Would you like to log into your git account?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    git config --global user.name "Eloquencere"
    echo -n "email ID: "
    read email
    git config --global user.email "$email"
    echo "you need to login to Github as well"
    gh auth login
    sed -i '/.* = $/d' $XDG_CONFIG_HOME/git/config
fi

# Clean up
rm -rf ~/.cache/* # generally safe, but be mindful
rm -rf ~/{.bash*,.profile,.zshrc,.zcompdump}
rm -rf ~/{Music,Templates,Public,go}
sudo rm -rf /tmp/*

BLOAT_SNAP=(
    "thunderbird" "firefox"
)
sudo snap remove --purge "${BLOAT_SNAP[@]}"

BLOAT_APT=(
    "gnome-logs" "gnome-calculator" "gnome-snapshot"
    "ptyxis" "deja-dup" "seahorse" "shotwell" "showtime"
    "rhythmbox" "orca" "info" "yelp" # WARN: "simple-scan"
    "transmission-common" "transmission-gtk"
    "ed" "vim-common" "nano"
    # Tools that clash with nixpkgs
    "git" "stow"
)
sudo nala purge -y "${BLOAT_APT[@]}"

sudo sh -c "nala install --fix-broken; nala autoremove; apt autoclean"
source ../continual-reference/software_updater.zsh
# WARN: terminal appears to exit here

echo "The system will reboot now to consolidate the installation"
read -r "?Press Enter to reboot..."
sudo reboot now

# # Auto-cpufreq
# git clone https://github.com/AdnanHodzic/auto-cpufreq.git
# cd auto-cpufreq/ && sudo ./auto-cpufreq-installer
# cd .. && rm -rf auto-cpufreq
# sudo auto-cpufreq --install

# # Improve Nautilus
# sudo nala install python3-nautilus python3-gi
# mkdir -p ~/.local/share/nautilus-python/extensions
# New File.. but adding slashes creates a Folder & there will be a preview of the icon if created, so Folder will have folder icon or Python file or empty file & even support {} like in the shell for muliple file creation
# Be able to copy a download link & right click on a folder in nautilus to Download link here.. (with wget)

# # Doom Emacs
# sudo nala install -y emacs-gtk
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# echo '# Doom Emacs
# export PATH=$XDG_CONFIG_HOME/emacs/bin:$PATH' >> ~/.zprofile

