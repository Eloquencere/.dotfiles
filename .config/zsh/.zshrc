# Set the directory of zinit and plugins
ZINIT_HOME="${ZDOTDIR}/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/ load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# Loading starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Aliases
alias n=nvim
alias neofetch=fastfetch

# Keybinds
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Bell
unsetopt BEEP

# History
HISTSIZE=5000
HISTFILE=~/.cache/zsh/.zsh_history
SAVEHIST=$HISTSIZE
HISDUP=erase
setopt appendhistory
setopt share_history
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_all_dups

# Completion styling
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath' # change this when I use a different ls and cd

alias ls='ls --color'

# Shell integrations
eval "$(fzf --zsh)"

# move all the aliases to .zprofile
# Usbip config
# sudo modprobe usbip-core
# sudo modprobe vhci-hcd
SERVER_IP=1
function usbip() {
	if [[ $1 == "attach" ]]; then
		shift
		sudo usbip attach --remote=$SERVER_IP "$@"
	elif [[ $1 == "detach" ]]; then
		shift
		sudo usbip detach "$@"
	fi
}

function lsusbip() {
	IFS=$'\n' read -r -d '' -A server_devices < <(usbip list --remote=$SERVER_IP | grep '^\s+[-0-9]+:')
	usbip_port_output=$(usbip port 2>/dev/null)
	printf "Devices from %s\n" "$SERVER_IP"
	printf "%-10s %-50s %-10s\n" "BUSID" "DEVICE" "PORT"
	regex='^\s+([-0-9]+):\s+(.*)\s+(\(.*\))$'
	for server_device in server_devices; do
		if [[server_device =~ regex ]]; then
			busid=$match[1]
			device_name=$match[2]
			vid_pid=$match[3]
		fi
	done
	port_number=$(echo "$usbip_port_output" | grep --before-context=1 --fixed-length "$vid_pid" | sed --silent '1s/.*\([-0-9]\+\):.*/\1/p')
	printf "%-10s %-50s %-10s\n" "$busid" "$device_name" "$port_number"
}
