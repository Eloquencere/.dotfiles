#! /bin/bash

cd ~/.dotfiles/scripts/installers

echo "Welcome to the *Ubuntu 24.04 LTS* installer for WSL :)
This script will automatically reboot the system after it is done"

sudo dpkg --add-architecture i386
sudo sh -c "apt update; apt upgrade -y"

sudo sh -c " echo 'LC_ALL=en_US.UTF-8' >> /etc/environment"
sudo sh -c " echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen"
sudo sh -c " echo 'LANG=en_US.UTF-8' > /etc/locale.conf"
sudo apt-get clean && sudo apt-get update
sudo locale-gen en_US.UTF-8

gsettings set org.gnome.mutter center-new-windows true

ESSENTIALS=(
	"libssl-dev" "liblzma-dev" "libreadline-dev" "libncurses5-dev" "libfuse2t64"
	"zlib1g-dev" "libbz2-dev" "libgdbm-dev" "libnss3-dev" "libreadline-dev" "libffi-dev"
	"python3-tk" "tk-dev"
	"libsqlite3-dev" "sqlite3" "stow" "curl"
	"build-essential" "xclip" "pkg-config"
    "7zip-full" "unrar"
	"nala"
	"x11-apps"
)
sudo apt-get install -y "${ESSENTIALS[@]}"

export CARGO_HOME="$HOME/.local/share/rust/cargo"
export RUSTUP_HOME="$HOME/.local/share/rust/rustup"
LANGUAGE_COMPILERS=(
    "rustup" "perl"
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

sudo nala install -y zsh
chsh --shell $(which zsh)

cd ./.dotfiles
stow .
cd -

sudo sh -c " echo '[boot]
command=\"service udev start\"' >> /etc/wsl.conf"

CLI_TOOLS=(
    "nixpkgs#starship" "nixpkgs#fzf" "nixpkgs#atuin" "nixpkgs#zoxide" "nixpkgs#mise"
    "nixpkgs#eza" "nixpkgs#fd" "nixpkgs#bat" "nixpkgs#ripgrep"
    "nixpkgs#duf" "nixpkgs#delta"
    "nixpkgs#croc" "nixpkgs#fastfetch"

    "nixpkgs#dos2unix" "nixpkgs#btop" "nixpkgs#yazi"
    "nixpkgs#jq" # jqp yq
    "nixpkgs#neovim" "nixpkgs#zellij" "nixpkgs#mprocs"
    "nixpkgs#conan" "nixpkgs#scriptisto" "nixpkgs#tio"
    "nixpkgs#gh" "nixpkgs#lazygit"
    "nixpkgs#podman" # look into Podman TUI
    "nixpkgs#tlrc" "nixpkgs#cheat"
    "nixpkgs#natural-docs" "nixpkgs#doxygen"
    "nixpkgs#restic" "nixpkgs#resticprofile"
)

# nix
sudo sh -c "echo '[boot]
[boot]
systemd=true
' >> /etc/wsl.conf"
zsh -li -c "sh <(curl -L https://nixos.org/nix/install) --daemon"
zsh -li -c "nix profile install "${CLI_TOOLS[@]}"; \
sudo update-alternatives --install /usr/bin/nvim editor \$(which nvim) 100"
zsh -li -c "mise install node@latest deno@latest go@latest python@3.12 python@2.7"


SOFTWARE_BLOAT=(
	"ed" "vim-common" "nano"
)
sudo nala purge -y "${SOFTWARE_BLOAT[@]}"

echo "Close and Re-open the terminal now"

