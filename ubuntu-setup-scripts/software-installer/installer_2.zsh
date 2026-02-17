#!/bin/zsh

nix profile add home-manager
home-manager switch
sudo update-alternatives --install /usr/bin/nvim editor $(which nvim) 100

# GUI setup
gnome-text-editor .gui_instructions.txt &

# NOTE: Need to see how to install & configure kanata

rustup toolchain install stable
rustup default stable
cargo install sccache

# Insall cpanm package manager for PERL
cpan App::cpanminus

mise install 'go@latest node@latest deno@latest python@latest python@2.7'

pip2 install --upgrade pip
pip install --upgrade pip

# Games
mkdir ~/Games
sudo snap install steam discord
GAMES_FLATPAK=(
    "com.heroicgameslauncher.hgl"
    # "com.parsecgaming.parsec"
)
flatpak install --assumeyes flathub "${GAMES_FLATPAK[@]}"

echo -n "Do you want to run a VM (Windows) on this machine?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    cd ~/Downloads
    wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.271-1/virtio-win.iso
    wget https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe
    sudo apt upgrade
    sudo nala install -y qemu-kvm bridge-utils virt-manager libosinfo-bin
    cd -
fi

mkdir -p $HOME/.config/zsh/personal

echo -n "Enter the ID granted by your admin to register with your team via croc: "
read croc_id
echo "# Croc
export CROC_SELF_TRANSFER_ID=$croc_id" >> $HOME/.config/zsh/personal/zprofile.zsh
echo "Move a copy of the collaborators database given by your admin to the zsh home directory"
mkdir ~/croc-inbox
echo "file://$HOME/croc-inbox" >> ~/.config/gtk-3.0/bookmarks

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
    git config --global user.email "$email"
    echo -n "username: "
    read username
    git config --global user.name "$username"
    echo "you need to login to Github as well"
    gh auth login
    sed -i '/.* = $/d' $HOME/.gitconfig
fi

rm -rf ~/.cache/thumbnails/*
rm -rf ~/{.bash*,.profile,.fontconfig}
sudo rm -rf ~/{Templates,Public,go,Music}
sed -i "/Music/d" ~/.config/gtk-3.0/bookmarks
# sed -i "/Videos\|Music/d" ~/.config/gtk-3.0/bookmarks
echo "file://$HOME/Projects" >> ~/.config/gtk-3.0/bookmarks

# Clean up
sudo sh -c "apt --fix-broken install; apt-get autoremove; apt-get autoclean"
flatpak uninstall --unused --delete-data --assumeyes
source ../continual-reference/software_updater.zsh

echo "The system will reboot now to consolidate the installation"
read -r "?Press Enter to reboot..."
sudo reboot now

