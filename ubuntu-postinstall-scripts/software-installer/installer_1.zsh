#!/bin/zsh

cd "$(dirname "${(%):-%x}")" # change directory to script location

echo "Welcome to the *Ubuntu 26.04 LTS* installer :)"

# WARN: need to verify default ubuntu 26.04 settings of dconf.nix & if the paths are still relevant
# TODO: install lemonade - reddit.com/r/LocalLLaMA/comments/1rqxc71/you_can_run_llms_on_your_amd_npu_on_linux/#:~:text=If%20you%20have%20a%20Ryzen%E2%84%A2%20AI%20300/400%2Dseries,just%20small%20demos%2C%20but%20real%20local%20inference
# TODO: General shell completions under the completions dir aren't working
# TODO: diff completion is good, delta is not showing hidden files

source sub-scripts/nerdfonts_download.sh
sudo nala install -y ttf-mscorefonts-installer fonts-crosextra-carlito fonts-crosextra-caladea # MS fonts for LibreOffice

# Performance improvement
sudo nala install -y preload earlyoom
sudo systemctl enable preload earlyoom

# Brave browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo nala update
sudo nala install -y brave-browser
xdg-settings set default-web-browser brave-browser.desktop
xdg-mime default brave-browser.desktop x-scheme-handler/mailto

# Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo nala update
sudo nala install -y wezterm

# Virt-Manager
cd ~/Downloads
sudo nala install -y qemu-kvm bridge-utils virt-manager libosinfo-bin
cd -

# KiCAD
sudo add-apt-repository --yes ppa:kicad/kicad-9.0-releases
sudo nala update
sudo nala install -y --install-recommends kicad

APPLICATIONS=(
    "gnome-shell-extension-manager"
    "bleachbit" "timeshift"
    "gufw"
)
sudo nala install -y "${APPLICATIONS[@]}"

# Only keep 2 versions of a snap pkg (curr & prev)
sudo snap set system refresh.retain=2

OFFICE_SOFTWARE_SNAP=(
    "notion-desktop" # Not available anywhere else
)
sudo snap install "${OFFICE_SOFTWARE_SNAP[@]}"
sudo snap install obsidian --classic # In flatpak, write errors on mounted cloud drives

# Games
echo "ntsync" | sudo tee /etc/modules-load.d/ntsync.conf
mkdir -p ~/Games/{windows,switch}
sudo nala install steam
GAMES_FLATPAK=(
    "com.discordapp.Discord"
    "com.heroicgameslauncher.hgl" # ISSUE: White title bar
    "io.github.ryubing.Ryujinx"
    # "com.parsecgaming.parsec"
)
flatpak install --assumeyes flathub "${GAMES_FLATPAK[@]}"

# Flatpaks
ADDITIONAL_APPS_FLATPAK=(
    "it.mijorus.gearlever" # appimage management
    "com.surfshark.Surfshark"
    "org.videolan.VLC"
    # Project
    "com.jgraph.drawio.desktop" # ISSUE: White title bar
    "io.github.Qalculate"
    # "com.github.tenderowl.frog"
    # System
    "net.epson.epsonscan2"
    # Project Management
    "io.github.giantpinkrobots.varia"
    # "org.ghidra_sre.Ghidra"
    # "org.jitsi.jitsi-meet"
    "com.rustdesk.RustDesk"
    # # Games
    # "org.gnome.Chess"
    # "org.gnome.Sudoku"
    # "app.drey.MultiplicationPuzzle"
    # "org.gnome.Mahjongg"
    # "org.gnome.Crosswords"
    # "org.gnome.Mines"
)
flatpak install --assumeyes flathub "${ADDITIONAL_APPS_FLATPAK[@]}"
# xdg-mime default okular_okular.desktop application/pdf # WARN: might need to set this for papers

# Uncomment when resources still works when this snippet is run
# # fix to title bar rendering in a different color than the app
# flatpak install --assumeyes flathub org.gtk.Gtk3theme.Yaru-dark                                                                                       ╶╯
# flatpak override --user --env=GTK_THEME=Yaru-dark

# NOTE: following will take effect after (shell) restart

# Installing nix pkg manager
sh <(curl --proto "=https" --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes

cd $HOME/.dotfiles && stow . && cd -

echo "The system will reboot now to consolidate the installation"
sudo reboot now

# # Improve Nautilus
# sudo nala install python3-nautilus python3-gi
# mkdir -p ~/.local/share/nautilus-python/extensions
# New File.. but adding slashes creates a Folder & there will be a preview of the icon if created, so Folder will have folder icon or Python file or empty file & even support {} like in the shell for muliple file creation
# Open With <terminal> whatever the xdg defaults say about the terminal
# Be able to copy a download link & right click on a folder in nautilus to Download link here.. (with wget)

# # Experiment - breaks host to guest clipboard
# echo 'APT::Architecture-Variants "amd64v3";' | sudo tee /etc/apt/apt.conf.d/99amd64v3
# sudo apt update
# sudo apt full-upgrade -y

# # Xournal++
# sudo add-apt-repository --yes ppa:apandada1/xournalpp-stable
# sudo nala update
# sudo nala install -y xournalpp

