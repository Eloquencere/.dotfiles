#!/bin/zsh
set -o errexit \
    -o nounset \
    -o pipefail

cd "$(dirname "${(%):-%x}")" # change directory to script location
sudo -v

# GUI setup
open .gui_instructions.txt

# Mise
mise trust
mise install
rustup toolchain install stable
rustup default stable

# Kanata (nix) setup
sudo groupadd uinput
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' \
  | sudo tee /etc/udev/rules.d/99-uinput.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo usermod -aG input,uinput $USER

nix profile add 'nixpkgs#home-manager'
home-manager switch

# cpanm package manager for perl
echo $'Say "\033[1;33myes\033[0m" to the first & "\033[1;33msudo\033[0m" to the next question'
cpan App::cpanminus

mkdir -p $ZDOTDIR/personal
read -r "croc_id?Enter the ID granted by your admin to register with your team via croc: "
echo "# Croc
export CROC_SELF_TRANSFER_ID=$croc_id" >> $ZDOTDIR/personal/zprofile.zsh
echo "Move a copy of the collaborators database given by your admin to the zsh home directory"
mkdir -p ~/Transfers/croc
echo "file://$HOME/Transfers" >> $XDG_CONFIG_HOME/gtk-3.0/bookmarks

# Git
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
read -q "user_choice?Would you like to log into your git account (y/N)? "; echo
if [[ $user_choice =~ ^[Yy]$ ]]; then
    git config --global user.name "Eloquencere"
    read -r "email?Email ID: "
    git config --global user.email "$email"
    echo "you need to login to Github as well"
    gh auth login
    sed -i '/.* = $/d' $XDG_CONFIG_HOME/git/config
fi

# Speech to Text
sudo nala install -y libgirepository-2.0-dev
pkg-config --cflags --libs girepository-2.0
curl -fsSL \
  https://raw.githubusercontent.com/jatinkrmalik/vocalinux/main/install.sh \
  -o /tmp/vl.sh && \
bash /tmp/vl.sh --interactive

# Hermes
HERMES_DEP_APT=(
    "libportaudio2"
)
sudo nala install -y "${HERMES_DEP_APT[@]}"
# TODO: Do a clean, from scratch setup of Hermes & check if my config file has any bloat
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
# ignore everything & explicity add what I wanna version control in the hermes folder
# WARN: install - https://github.com/lfnovo/open-notebook

BLOAT_SNAP=(
    "thunderbird" "firefox"
)
sudo snap remove --purge "${BLOAT_SNAP[@]}"

BLOAT_APT=(
    "gnome-calculator"
    "ptyxis" "deja-dup" "seahorse" "shotwell" "showtime"
    "rhythmbox" "orca" "brltty" "info" "simple-scan"
    "ed" "vim-common" "nano"
    # Tools that clash with nixpkgs
    "stow"
)
sudo nala purge -y "${BLOAT_APT[@]}"

sudo nala install --fix-broken
source ../continual-reference/software_updater.zsh

# Clean up
rm -f ~/{.bash*,.profile,.zshrc,.zcompdump}
rm -rf ~/.mozilla # NOTE: Check if anything else can be removed
rm -rf ~/.cache/*

read "?Address all other open windows & Press Enter to reboot and consolidate the installation..."
sudo reboot now

# # Auto-cpufreq
# git clone https://github.com/AdnanHodzic/auto-cpufreq.git
# cd auto-cpufreq/ && sudo ./auto-cpufreq-installer
# cd .. && rm -rf auto-cpufreq
# sudo auto-cpufreq --install

# # Doom Emacs
# sudo nala install -y emacs-gtk
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
# ~/.config/emacs/bin/doom install
# echo '# Doom Emacs
# export PATH=$XDG_CONFIG_HOME/emacs/bin:$PATH' >> ~/.zprofile

# # Improve Nautilus
# sudo nala install python3-nautilus python3-gi
# mkdir -p ~/.local/share/nautilus-python/extensions
# New.. but adding slashes creates a Folder & there will be a preview of the icon if created, so Folder will have folder icon or Python file or empty file & even support {} like in the shell for muliple file creation
# Be able to copy a download link & right click on a folder in nautilus to Download link here.. (with wget)

