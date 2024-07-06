# Bell
unsetopt BEEP

# History
HISTFILE="$XDG_DATA_HOME/zsh/.zsh_history"
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISDUP=erase
export HISTTIMEFORMAT="[%F %T] "
setopt extended_history
setopt append_history
setopt share_history
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_all_dups

# Completions
autoload -Uz compinit && compinit
_comp_options+=(globdots) # Show hidden files
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '#%d'
zstyle ':completion:*' menu no
zstyle ':completion:*' group-name '' # Group the completions by type

# Enable colors
autoload -Uz colors && colors

# setopts
setopt extendedglob # enables regex
setopt nobeep 
setopt autocd

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

# ------- Local ------

# Zsh-Vi-Mode
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
# bindkey '^p' line-up-or-search
# bindkey '^n' line-down-or-search

# fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exculde .git"

# fzf-tab
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:*' show-group full
zstyle ':fzf-tab:*' switch-group ctrl-h ctrl-l # Change keybinding to switch groups
zstyle ':fzf-tab:*' single-group color header # Show type even when only one group
# Increase fzf prompt size
zstyle ':fzf-tab:*' fzf-pad 5
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:complete:(cd|ls|jq|touch|source):*' fzf-preview '[[ -d $realpath ]] && eza -1 --color=always --icons=always --all $realpath'
zstyle ':fzf-tab:complete:((cp|mv|rm|cat|code|nvim|n):argument-rest|kate:*)' fzf-preview 'bat --color=always -- $realpath 2>/dev/null || eza -1 --color=always --icons=always --all -- $realpath'

# Shell integrations
source <(starship init zsh)
source <(fzf --zsh)
source <(zoxide init --cmd cd zsh)
source <(pyenv init -)

# Source aliases & functions
[[ ! -f "$ZDOTDIR/zsh-aliases.sh" ]] || source "$ZDOTDIR/zsh-aliases.sh"
[[ ! -f "$ZDOTDIR/zsh-functions.sh" ]] || source "$ZDOTDIR/zsh-functions.sh"
