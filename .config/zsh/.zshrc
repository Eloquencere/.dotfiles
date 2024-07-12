# setopts
setopt correct
setopt nobeep

# History
HISTFILE="$XDG_DATA_HOME/zsh/.zsh_history"

# Completions
autoload -Uz compinit && compinit -i
setopt extendedglob # enables regex
_comp_options+=(globdots) # Show hidden files
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# Enable colors
autoload -Uz colors && colors

# Set the directory for zinit and it's plugins
ZINIT_HOME="${XDG_DATA_HOME}/zsh/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Improving performance
zinit cdreplay -q

# Add Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit load atuinish/atuin

# ------- Local ------

# Zsh-Vi-Mode
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

# fzf-tab
zinit light Aloxaf/fzf-tab
# Increase fzf prompt size
zstyle ':fzf-tab:*' fzf-pad 5
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:complete:(cd|ls|jq|touch|source):*' fzf-preview '[[ -d $realpath ]] && eza --oneline --color=always --icons=always --all $realpath'
zstyle ':fzf-tab:complete:((cp|mv|rm|cat|nvim):argument-rest|kate:*)' fzf-preview 'bat --color=always -- $realpath 2>/dev/null || eza --oneline --color=always --icons=always --all -- $realpath'

# Shell integrations
source <(starship init zsh)
source <(fzf --zsh)
source <(atuin init zsh)
source <(zoxide init --cmd cd zsh)
source <(hub alias -s)

# Source aliases & functions
[[ ! -f "$ZDOTDIR/zsh-aliases.sh" ]] || source "$ZDOTDIR/zsh-aliases.sh"
[[ ! -f "$ZDOTDIR/zsh-functions.sh" ]] || source "$ZDOTDIR/zsh-functions.sh"
