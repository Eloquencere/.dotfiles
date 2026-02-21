# options
setopt nobeep
setopt correct
# setopt extended_glob
setopt interactive_comments

# Loading zinit
source "$XDG_DATA_HOME/zinit-pkgmngr/zinit.zsh"

zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light-mode for \
  jeffreytse/zsh-vi-mode \
  Aloxaf/fzf-tab

zinit ice wait'1' lucid
zinit light-mode for \
  hlissner/zsh-autopair \
  zsh-users/zsh-completions \
  Eloquencere/zsh-goto-cli
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

# Initialising completions directory
if [[ -d $ZDOTDIR/completion ]]; then
    fpath+=$ZDOTDIR/completion
fi

autoload -Uz colors && colors
autoload -Uz compinit && compinit -C
_comp_options+=(globdots) # Show hidden files
zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-pad 5
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:complete:(cd|ls|touch):*' fzf-preview '[[ -d $realpath ]] && eza --oneline --group-directories-first --color=always --icons=always --all $realpath'
zstyle ':fzf-tab:complete:((cp|mv|rm|nvim|jq|bat|delta):argument-rest|kate:*)' fzf-preview 'bat --color=always -- $realpath 2>/dev/null || eza --oneline --color=always --icons=always --all -- $realpath'

# Shell integrations
eval "$(starship init zsh)"

# Lazy-load the rest on first prompt
autoload -Uz add-zsh-hook
function lazy_shell_tools {
    eval "$(fzf --zsh)"
    eval "$(atuin init zsh --disable-ctrl-r --disable-up-arrow)"
    eval "$(zoxide init --cmd cd zsh)"
    eval "$(mise activate zsh)"
    add-zsh-hook -d precmd lazy_shell_tools
}
add-zsh-hook precmd lazy_shell_tools

# Personal confidential variables
if [[ -f "$ZDOTDIR/personal/zshrc.zsh" ]]; then
    source "$ZDOTDIR/personal/zshrc.zsh"
fi
# aliases & functions
source "$ZDOTDIR/zsh-aliases.zsh"
source "$ZDOTDIR/zsh-functions.zsh"

# Zsh-Vi-Mode
function zvm_config() {
    ZVM_INIT_MODE=sourcing # https://github.com/jeffreytse/zsh-vi-mode#initialization-mode
}
function zvm_after_init() {
	zvm_bindkey viins '^r' atuin-search
	zvm_bindkey viins '^p' atuin-up-search
}

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

