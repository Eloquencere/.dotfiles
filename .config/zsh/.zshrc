# options
setopt nobeep
setopt correct
setopt autocd

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add zinit plugins
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab
zinit load atuinsh/atuin

autoload -Uz colors && colors
autoload -Uz compinit && compinit
_comp_options+=(globdots) # Show hidden files
zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-pad 5
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:complete:(cd|ls|jq|touch):*' fzf-preview '[[ -d $realpath ]] && eza --oneline --color=always --icons=always --all $realpath'
zstyle ':fzf-tab:complete:((cp|mv|rm|source|cat|nvim):argument-rest|kate:*)' fzf-preview 'bat --color=always -- $realpath 2>/dev/null || eza --oneline --color=always --icons=always --all -- $realpath'

# Shell integrations
source <(starship init zsh)
source <(atuin init zsh)
source <(fzf --zsh)
source <(zoxide init --cmd cd zsh)
source <(hub alias -s)

# Source aliases & functions
[[ ! -f "$ZDOTDIR/zsh-aliases.zsh" ]] || source "$ZDOTDIR/zsh-aliases.zsh"
[[ ! -f "$ZDOTDIR/zsh-functions.zsh" ]] || source "$ZDOTDIR/zsh-functions.zsh"

function zvm_after_init() {
	# Zsh-Vi-Mode
	ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
	zvm_bindkey viins '^r' atuin-search
	zvm_bindkey vicmd '^r' atuin-search
	zvm_bindkey viins '^p' atuin-up-search
}
