#! /bin/bash

cd ~/.dotfiles/scripts/installers

echo "Welcome to part 2 of the *Ubuntu 24.04 LTS* installer"
sleep 2

# cpanm package manager
cpan App::cpanminus

# # Useful Python libraries
# pip2 install --upgrade pip
# pip install --upgrade pip
# pip install icecream # for debugging
# pip install drawio colorama pyfiglet # presentation
# pip install dash plotly seaborn mysql-connector-python # data representation and calculation
# pip install fireducks xarray
# pip install numpy scipy pillow
# pip install Cython numba taichi
# pip install parse pendulum pydantic ruff mypy pyglet
# pip install keras scikit-learn torch # AI/ML

# Useful Rust binaries
CARGO_PKGS=(
    "cargo-expand" "irust" "bacon"
)
cargo install "${CARGO_PKGS[@]}"

mkdir -p $ZDOTDIR/personal

echo -n "Enter the ID granted by your admin to register with your team via croc: "
read croc_id
echo "# Croc
export CROC_SELF_TRANSFER_ID=$croc_id" >> $ZDOTDIR/personal/zprofile.zsh
echo "Move a copy of the collaborators database given by your admin to the zsh home directory"
mkdir ~/croc-inbox

echo -n "What is your default browser on Windows?
b -> brave
gc -> google chrome"
read browser_choice
if [[ $browser_choice == "b" ]]; then
    export BROWSER=brave.exe >> $HOME/.config/zsh/personal/zprofile.zsh
else
    export BROWSER=chrome.exe >> $HOME/.config/zsh/personal/zprofile.zsh
fi

echo -n "Would you like to configure USBIP?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
	echo -n "Enter the server address: "
	read server_ip
	echo "
# USBIP
export SERVER_IP=$server_ip" >> $HOME/.config/zsh/personal/zprofile.zsh
fi
sudo sh -c "echo '# usbip client
usbip-core
vhci-hcd' > /etc/modules-load.d/usbip.conf"

echo -n "Would you like to log into your git account?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Yy]$ ]]; then
    git config --global init.defaultBranch main
    git config --global core.whitespace error
    git config --global core.preloadindex true
    git config --global core.editor nvim
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.navigate true  # use n and N to move between diff sections
    git config --global delta.dark true
    git config --global delta.side-by-side true
    git config --global merge.conflictstyle diff3
    git config --global diff.colorMoved default
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

# Clean up
rm -rf ~/{.bash*,.profile}

sudo sh -c "apt-get update; apt-get dist-upgrade; apt-get autoremove; apt-get autoclean; apt --fix-broken install"
nix-collect-garbage --delete-old; nix store gc
# flatpak uninstall --unused --delete-data --assumeyes

source $HOME/.dotfiles/scripts/continual-reference/software_updater.zsh

echo "Close and re-open the terminal again"
sleep 3

#### end ####

# ## cuda WSL support
# wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
# sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
# wget https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-wsl-ubuntu-12-8-local_12.8.1-1_amd64.deb
# sudo dpkg -i cuda-repo-wsl-ubuntu-12-8-local_12.8.1-1_amd64.deb
# sudo cp /var/cuda-repo-wsl-ubuntu-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
# sudo apt-get update
# sudo apt-get -y install cuda-toolkit-12-8
# rm -f cuda-repo-wsl-ubuntu-12-8-local_12.8.1-1_amd64.deb


## Optional
# sudo apt-get install iproute2 gawk build-essential gcc git make net-tools tftpd-hpa zlib1g-dev libssl-dev flex bison libselinux1 gnupg wget git diffstat chrpath socat xterm autoconf libtool tar unzip texinfo zlib1g-dev gcc-multilib automake zlib1g:i386 screen pax gzip cpio python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libsdl1.2-dev pylint bc subversion u-boot-tools -y
