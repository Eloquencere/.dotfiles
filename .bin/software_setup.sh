mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Basic setup
sudo sed -i "s/^\(GRUB_DEFAULT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT_STYLE=\).*/\1hidden/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo sed -i "s/^#\(Color\)/\1\nILoveCandy/g" /etc/pacman.conf
sudo sed -i "s/^#\(ParallelDownloads .*\)/\1/g" /etc/pacman.conf

# Temporary setup for zsh shell
yes | sudo pacman -S zsh
chsh -s $(which zsh)
yes | sudo pacman -S neovim
rm -f ~/.bash*

# Basic software
yes | sudo pacman -S arch-wiki-docs arch-wiki-lite
yes | sudo pacman -S p7zip unrar tar exfat-utils ntfs-3g
yes | sudo pacman -S libreoffice-fresh vlc
yes | sudo pacman -S fastfetch btop # benchmarkers
yes | sudo pacman -S stow gnu-netcat speedtest-cli
# Others
# yay -S preload # to open up software faster
# sudo systemctl enable preload; sudo systemctl start preload
# Auto cpu-freq

# Uninstall bloat
yes | sudo pacman -Rs epiphany # Remove browser
# gstreamer1.0-vaapi # video player
# and contacts, weather, tour

# Installing yay and git and curl
echo "Installing yay AUR package manager"
yes | sudo pacman -Syu
yes | sudo pacman -S base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
yes | makepkg -si
echo "Done, cleaning up"
cd ..
rm -rf yay/
yes | sudo pacman -S flatpak

# Initialising all dot files
cd ~/.dotfiles
stow .
cd -

# Zsh-vi-mode plugin
echo "zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.config/zsh/.zshrc "# Add Plugins"
echo "ZVM_LINE_INIT_MODE=\$ZVM_MODE_INSERT
# Keybinds
# bindkey '^p' line-up-or-search
# bindkey '^n' line-down-or-search" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.config/zsh/.zshrc "# zsh-vi-mode config"

echo "alias n=nvim
alias neofetch=fastfetch" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.config/zsh/zsh-aliases.sh "# Basic tools"

# Install fonts
yes | sudo pacman -S ttf-jetbrains-mono-nerd

# Alacritty Terminal Emulator
yes | sudo pacman -S alacritty starship 
echo "eval "\$(starship init zsh)"" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.config/zsh/.zshrc "# Shell integrations"
echo "export STARSHIP_CONFIG=\${XDG_CONFIG_HOME}/starship/starship.toml" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.zprofile "# Starship"
yes | sudo pacman -S zellij xclip
yay -S tio

# Command line tools
yes | sudo pacman -S fzf zoxide eza bat fd ripgrep

echo "zinit light Aloxaf/fzf-tab" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.config/zsh/.zshrc "# Add Plugins"
echo "zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons=always --all --long --no-filesize --no-user --no-time --no-permissions $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons=always --all --long --no-filesize --no-user --no-time --no-permissions $realpath'" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.config/zsh/.zshrc "# fzf-tab config"

echo "eval "\$(fzf --zsh)"
eval "\$(zoxide init --cmd cd zsh)"" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.config/zsh/.zshrc "# Shell integrations"

echo " alias ls="eza --color=always --icons=always --git"
alias tree="ls --tree --git-ignore"
alias find=fd
alias cat=bat
alias grep=rg" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.config/zsh/zsh-aliases.sh "# Better command line utils"

yes | sudo pacman -S  gdu duf jq
echo "alias df=duf" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.config/zsh/zsh-aliases.sh "# Better command line utils"

sudo pacman -S man
yay -S tlrc-bin

# Brave
echo "Installing Brave"
echo "Just keep pressing 'Enter' From here on"
yay -S brave-bin
echo "Done"

# Language compilers and related packages - install these as early as possible in the script
sudo pacman -S gdb valgrind strace ghidra
yes | sudo pacman -S --needed clang lldb
yes | sudo pacman -S nodejs-lts-iron

# Get the appropriate profilers for all other necessary programming languages
# yes | sudo pacman -S zig
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # Rust
# echo "export PATH=$HOME/.cargo/bin:$PATH" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.zprofile "# Rust"
# curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh # Haskell

yes | sudo pacman -S --needed perl go python
yes | sudo pacman -S python-pip pyenv
echo "# export PYENV_ROOT="\$HOME/.pyenv"
[[ -d PYENV_ROOT/bin ]] && export PATH="\$PYENV_ROOT/bin":\$PATH
eval "\$(pyenv init -)"" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.zprofile "# pyenv"

# Onedriver
# mkdir $HOME/OneDrive
# yay -S onedriver
# rm -rf ~/Music ~/Pictures ~/Templates ~/Public

# Remote machine tools
yes | sudo pacman -S usbip
sudo sh -c "printf '%s\n%s\n' 'usbip-core' 'vhci-hcd' >> /etc/modules-load.d/usbip.conf" # adding basic conf to usbip 
# ask the user for serverip
echo "SERVER_IP=1
function usbip() {
	if [[ \$1 == "attach" ]]; then
		shift
		sudo usbip attach --remote=\$SERVER_IP "\$@"
	elif [[ \$1 == "detach" ]]; then
		shift
		sudo usbip detach "\$@"
	else
		command usbip "\$@"
	fi
}

function lsusbip() {
	IFS=$'\n' read -r -d '' -A server_devices < <(usbip list --remote=\$SERVER_IP | grep --regexp "^\s+[-0-9]+:") # might need to add local IFS=
	usbip_port_output=$(usbip port 2>/dev/null)
	printf "Devices from %s\n" "\$SERVER_IP"
	printf "%-10s %-50s %-10s\n" "BUSID" "DEVICE" "PORT"
	regex="^\s+([-0-9]+):\s+(.*)\s+(\(.*\))$"
	for server_device in \$server_devices; do
		if [[ \$server_device =~ \$regex ]]; then
			busid=\$match[1]
			device_name=\$match[2]
			vid_pid=\$match[3]
		fi
	done
	port_number=$(echo "\$usbip_port_output" | grep --before-context=1 "\$vid_pid" | sed --silent '1s/.*\([-0-9]\+\):.*/\1/p')
	printf "%-10s %-50s %-10s\n" "\$busid" "\$device_name" "\$port_number"
}" | python ~/.dotfiles/.bin/conf_conf_file.py ~/.zprofile "# Usbip config"
# yay -S nomachine

# Seting up backup schemes (timeshift)
# betterfs for better backup & setup encrypted HDD

# Gnome Desktop Config
# Bring minimise, maximise and close buttons to their positions
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font' 

cd ~/Documents
rm -rf install_script_temp_folder

echo "Reboot the system now"
