# TODO: when installing these packages look out for install recommendations or suggestions & add that flag to apt
# TODO : how to specify pip packages to be installed in mise declaratively

# Load wallpaper once
gsettings set org.gnome.desktop.background picture-uri-dark "file://$DOTFILES_HOME/wallpapers/angkor_watt_gpt.png"
gsettings set org.gnome.desktop.background picture-options 'stretched'

source nerdfonts_download.sh

# performance improvement software
sudo apt install -y preload
sudo systemctl enable preload

# Optional compiler - use apt only
sudo apt install clang lldb

# Brave browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser
xdg-settings set default-web-browser brave-browser.desktop

# Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install -y wezterm

# KiCAD
sudo add-apt-repository --yes ppa:kicad/kicad-9.0-releases
sudo apt update
sudo apt install --install-recommends -y kicad

# Virt-Manager
cd ~/Downloads
sudo apt install -y qemu-kvm bridge-utils virt-manager libosinfo-bin
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.271-1/virtio-win.iso
wget https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe
cd -

APPLICATIONS=(
    "gnome-shell-extension-manager"
    "bleachbit" "timeshift"
    "kdeconnect" "gufw"
)
sudo apt install -y "${APPLICATIONS[@]}"

OFFICE_SOFTWARE_SNAP=(
    "notion-desktop" "drawio" "qalculate"
    "surfshark" "varia"
)
sudo snap install "${OFFICE_SOFTWARE_SNAP[@]}"
sudo snap install obsidian --classic

# Games
mkdir ~/Games
sudo apt install steam --install-suggests
sudo snap install discord
GAMES_FLATPAK=(
    "com.heroicgameslauncher.hgl"
    # "com.parsecgaming.parsec"
)
flatpak install --assumeyes flathub "${GAMES_FLATPAK[@]}"

# Flatpaks
ADDITIONAL_APPS_FLATPAK=(
    "org.videolan.VLC"
    "org.kde.okular"
    # Electronics - NOTE: might be better to add to a separate hdl script
    "com.github.reds.LogisimEvolution"
    # System
    "net.nokyan.Resources" # - WARN: default in 26.04LTS
    "net.epson.epsonscan2"
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

# GUI setup
gnome-text-editor .gui_instructions.txt &

source /etc/profile.d/nix.sh # to get nix in this shell instance

# Kanata install & config
nix profile add nixpkgs#kanata
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

nix profile add nixpkgs#home-manager
home-manager switch
home-manager news &> /dev/null

sudo update-alternatives --install /usr/bin/nvim editor $(which nvim) 100

# Necessary libs to build cargo & python
sudo apt-get install -y \
  libssl-dev zlib1g-dev libbz2-dev liblzma-dev \
  libreadline-dev libsqlite3-dev libncursesw5-dev \
  libffi-dev tk-dev tcl-dev \
  libgdbm-dev uuid-dev libexpat1-dev

unset RUSTC_WRAPPER # to momentarily disable cargo from pointing to uninstalled sccache
rustup toolchain install stable
rustup default stable
# cargo install sccache # WARN: freezes here

mise trust # config file
mise install # from config

pip2 install --upgrade pip
pip install --upgrade pip

echo "Say \"yes\" first & \"sudo\" to the next question"

# cpanm package manager for perl
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
    git config --global init.defaultBranch main
    git config --global core.whitespace error
    git config --global core.preloadindex true
    git config --global core.editor nvim
    git config --global core.pager delta
    git config --global delta.navigate true
    git config --global delta.dark true
    git config --global delta.side-by-side true
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global diff.colorMoved default
    git config --global merge.conflictstyle diff3
    echo -n "email ID: "
    read email
    git config --global user.email "Eloquencere"
    git config --global user.name "$username"
    echo "you need to login to Github as well"
    gh auth login
    sed -i '/.* = $/d' $HOME/.gitconfig
fi

# Clean up
echo "file://$HOME/Projects" >> $XDG_CONFIG_HOME/gtk-3.0/bookmarks
sed -i "/Music/d" $XDG_CONFIG_HOME/gtk-3.0/bookmarks
# sed -i "/Videos\|Music/d" $XDG_CONFIG_HOME/gtk-3.0/bookmarks

rm -rf ~/.cache/* # generally safe, but be mindful
rm -rf ~/{.bash*,.profile,.fontconfig}
rm -rf ~/.mozilla/firefox/*/cache2/*
sudo rm -rf ~/{Templates,Public,go,Music}
sudo rm -rf rm -rf /tmp/*

BLOAT_SNAP=(
    "thunderbird"
)
sudo apt-get purge -y "${BLOAT_SNAP[@]}"
sudo snap remove "${BLOAT_SNAP[@]}"

BLOAT_APT=(
    "ed" "vim-common" "nano"
    "transmission-common" "transmission-gtk"
    "rhythmbox" "orca" "info" "yelp"
    "gnome-snapshot" "gnome-logs" "gnome-terminal"
    "gnome-system-monitor" "gnome-power-manager"
    "deja-dup" "seahorse" "shotwell" "evince" "gnome-calculator"
    # cli tools that clash with nix
    "git" "curl" "stow"
    # WARN: depricated in ubuntu 26.04 LTS to - "showtime"
    "totem"
)
sudo apt purge -y "${BLOAT_APT[@]}"

sudo sh -c "apt --fix-broken install; apt-get autoremove; apt-get autoclean"
flatpak uninstall --unused --delete-data --assumeyes
source ../../continual-reference/software_updater.zsh



# # Auto-cpufreq
# git clone https://github.com/AdnanHodzic/auto-cpufreq.git
# cd auto-cpufreq && sudo ./auto-cpufreq-installer
# cd .. && rm -rf auto-cpufreq
# sudo auto-cpufreq --install

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

