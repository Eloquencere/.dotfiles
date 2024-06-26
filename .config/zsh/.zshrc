# Set the directory of zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME}/zsh/zinit.git"

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
# find vim mode plugin

# Load completions
autoload -U compinit && compinit
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath' # change this when I use a different ls and cd
_comp_options+=(globdots) # Show hidden files

# Enable colors and change prompt
autoload -U colors && colors

zinit cdreplay -q

# Bell
unsetopt BEEP

# History
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=${XDG_CACHE_HOME}/zsh/.zsh_history
HISDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_all_dups

# Basic files to source
[ -f "$ZDOTDIR/zsh-aliases.zsh" ] && source "$ZDOTDIR/zsh-aliases.zsh"
[ -f "$ZDOTDIR/zsh-functions.zsh" ] && source "$ZDOTDIR/zsh-functions.zsh"

# Keybinds
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -s '^o' 'clear\n'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(starship init zsh)" # Loading starship

# Aliases
alias ls='ls --color'
alias n=nvim
alias neofetch=fastfetch

# Functions

