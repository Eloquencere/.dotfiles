# options
setopt nobeep
setopt correct
setopt interactive_comments

# Initialising completions directory
fpath=($ZDOTDIR/completion $fpath)

# Loading zinit
source "$ZDOTDIR/zinit/zinit.zsh"

# zinit plugins
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz edit-command-line; zle -N edit-command-line
_comp_options+=(globdots) # Show hidden files
zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-pad 5
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:complete:(cd|ls|jq|touch):*' fzf-preview '[[ -d $realpath ]] && eza --oneline --group-directories-first --color=always --icons=always --all $realpath'
zstyle ':fzf-tab:complete:((cp|mv|rm|nvim):argument-rest|kate:*)' fzf-preview 'bat --color=always -- $realpath 2>/dev/null || eza --oneline --color=always --icons=always --all -- $realpath'

# Shell integrations
source <(starship init zsh)
source <(fzf --zsh)
source <(atuin init zsh --disable-up-arrow)
source <(zoxide init --cmd cd zsh)
source <(mise activate zsh)

# Personal confidential variables
if [[ -f "$ZDOTDIR/personal/zshrc.zsh" ]]; then
    source "$ZDOTDIR/personal/zshrc.zsh"
fi
# aliases & functions
source "$ZDOTDIR/zsh-aliases.zsh"
source "$ZDOTDIR/zsh-functions.zsh"

# Zsh-Vi-Mode
function zvm_after_init() {
	ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
	zvm_bindkey viins '^r' atuin-search
	zvm_bindkey viins '^p' atuin-up-search
	# zvm_bindkey viins '^Xe' edit-command-line
}
function zvm_after_lazy_keybindings() {
    zvm_bindkey vicmd '^r' atuin-search
	zvm_bindkey vicmd '^p' atuin-up-search
}

# FZF modifications
_fzf_compgen_path() {
    fd --follow --hidden --exclude .git . "$1" --color=always
}
_fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1" --color=always
}


zellij_tab_name_update() {
    if [[ -n $ZELLIJ ]]; then
        local current_dir=$PWD
        if [[ $current_dir == $HOME ]]; then
            current_dir="~"
        else
            current_dir=${current_dir##*/}
        fi
        command nohup zellij action rename-tab $current_dir >/dev/null 2>&1
    fi
}
zellij_tab_name_update
chpwd_functions+=(zellij_tab_name_update)
