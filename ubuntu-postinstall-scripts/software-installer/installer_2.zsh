#!/bin/zsh

cd "$(dirname "${(%):-%x}")" # change directory to script location

# Add this to dconf.nix Alternatively, take a call to completely remove the notifier app
gsettings set com.ubuntu.update-notifier no-show-notifications true
gsettings set org.gnome.desktop.datetime automatic-timezone true

# Load wallpaper once
gsettings set org.gnome.desktop.background picture-uri-dark "file://$DOTFILES_HOME/wallpapers/angkor_watt_gpt.png"
gsettings set org.gnome.desktop.background picture-options 'stretched'

echo "Click on 'Move to App Menu'"

# LM Studio
wget -O lm-studio.AppImage 'https://lmstudio.ai/download/latest/linux/x64?format=AppImage'
flatpak run it.mijorus.gearlever lm-studio.AppImage

# GUI setup
gnome-text-editor .gui_instructions.txt &

nix profile add nixpkgs#home-manager
home-manager switch
home-manager news &> /dev/null

# Kanata setup
sudo groupadd uinput
sudo usermod -aG input,uinput $USER
sudo sh -c "echo '# Kanata
KERNEL==uinput, MODE=0660, GROUP=uinput, OPTIONS+=static_node=uinput' >> /etc/udev/rules.d/99-input.rules"
sudo sh -c "echo '[Unit]
Description=Kanata keyboard remapper

[Service]
Type=simple
ExecStartPre=/sbin/modprobe uinput
ExecStart=$(which kanata) --cfg $XDG_CONFIG_HOME/kanata/config.kbd
Restart=no

[Install]
WantedBy=default.target' > /lib/systemd/system/kanata.service"
sudo systemctl enable kanata

# Necessary libs to build cargo & python
sudo nala install -y \
    libssl-dev zlib1g-dev libbz2-dev liblzma-dev \
    libreadline-dev libsqlite3-dev libncursesw5-dev \
    libffi-dev tk-dev tcl-dev \
    libgdbm-dev uuid-dev libexpat1-dev

rustup toolchain install stable
rustup default stable
unset RUSTC_WRAPPER # to momentarily disable cargo from pointing to uninstalled sccache
cargo install sccache

mise trust # config file
mise install # from config
# WARN: python install not happening

pip2 install --upgrade pip
pip install --upgrade pip

# cpanm package manager for perl
echo "Say \"yes\" to the first & \"sudo\" to the next question"
cpan App::cpanminus

mkdir -p $ZDOTDIR/personal
echo -n "Enter the ID granted by your admin to register with your team via croc: "
read croc_id
echo "# Croc
export CROC_SELF_TRANSFER_ID=$croc_id" >> $ZDOTDIR/personal/zprofile.zsh
echo "Move a copy of the collaborators database given by your admin to the zsh home directory"
mkdir ~/croc-inbox
echo "file://$HOME/croc-inbox" >> $XDG_CONFIG_HOME/gtk-3.0/bookmarks

echo -n "Would you like to log into your git account?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    mkdir $XDG_CONFIG_HOME/git
    touch $XDG_CONFIG_HOME/git/config
    git config --file $XDG_CONFIG_HOME/git/config init.defaultBranch main
    git config --global core.whitespace error
    git config --global core.preloadindex true
    git config --global core.editor $EDITOR
    git config --global core.pager delta
    git config --global delta.navigate true
    git config --global delta.dark true
    git config --global delta.side-by-side true
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global diff.colorMoved default
    git config --global merge.conflictstyle diff3
    git config --global user.name "Eloquencere"
    echo -n "email ID: "
    read email
    git config --global user.email "$email"
    echo "you need to login to Github as well"
    gh auth login
    sed -i '/.* = $/d' $XDG_CONFIG_HOME/git/config
fi

mkdir -p $HOME/Projects
echo "file://$HOME/Projects" >> $XDG_CONFIG_HOME/gtk-3.0/bookmarks
sed -i "\|Music|d" $XDG_CONFIG_HOME/gtk-3.0/bookmarks

# Clean up
rm -rf ~/.cache/* # generally safe, but be mindful
rm -rf ~/{.bash*,.profile}
rm -rf ~/{Templates,Public,go,Music}
sudo rm -rf /tmp/*

BLOAT_SNAP=(
    "thunderbird"
)
sudo nala purge -y "${BLOAT_SNAP[@]}"
sudo snap remove "${BLOAT_SNAP[@]}"

BLOAT_APT=(
    "gnome-snapshot" "gnome-logs" "gnome-calculator"
    "gnome-power-manager" "ptyxis"
    "deja-dup" "seahorse" "shotwell" "papers" "showtime"
    "rhythmbox" "orca" "info" "yelp"
    "transmission-common" "transmission-gtk"
    "ed" "vim-common" "nano"
    # cli tools that clash with nix
    "git" "stow"
)
sudo nala purge -y "${BLOAT_APT[@]}"

sudo sh -c "nala install --fix-broken; nala autoremove; apt autoclean"
flatpak uninstall --unused --delete-data --assumeyes
source ../continual-reference/software_updater.zsh

echo "The system will reboot now to consolidate the installation"
read -r "?Press Enter to reboot..."
sudo reboot now


# # Getting nix cli in this shell instance
# source /etc/profile.d/nix.sh

# # Optional C compiler - don't install via nix
# sudo nala install clang lldb

# # Auto-cpufreq
# git clone https://github.com/AdnanHodzic/auto-cpufreq.git
# cd auto-cpufreq && sudo ./auto-cpufreq-installer
# cd .. && rm -rf auto-cpufreq
# sudo auto-cpufreq --install

# # WinBoat
# winboat_version="0.9.0"
# wget -O winboat.AppImage 'https://github.com/TibixDev/winboat/releases/download/v$winboat_version/winboat-$winboat_version-x86_64.AppImage'
# flatpak run it.mijorus.gearlever winboat.AppImage

# # Signal
# wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
# cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
# echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
#   sudo tee /etc/apt/sources.list.d/signal-xenial.list
# sudo apt update && sudo apt install signal-desktop
# rm -rf signal-desktop-keyring.gpg

# # VSCode
# wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
# sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
# sudo apt install -y apt-transport-https && sudo apt update
# sudo apt install code
# rm -f packages.microsoft.gpg

# # Doom Emacs
# sudo nala install -y emacs-gtk
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# echo '# Doom Emacs
# export PATH=$XDG_CONFIG_HOME/emacs/bin:$PATH' >> ~/.zprofile

