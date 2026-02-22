# options
setopt nobeep
setopt correct
# setopt extended_glob
setopt interactive_comments

source "$XDG_DATA_HOME/zinit-pkgmngr/zinit.zsh"

# # Disabled at the moment
# zinit ice wait lucid silent compile blockf
# zinit light zsh-users/zsh-completions

# Initialising completions directory
if [[ -d $ZDOTDIR/completion ]]; then
    fpath+=$ZDOTDIR/completion
fi

autoload -Uz compinit && compinit -C
zinit cdreplay -q
_comp_options+=(globdots) # Show hidden files

zinit ice wait lucid silent compile
zinit light-mode for \
  jeffreytse/zsh-vi-mode \
  hlissner/zsh-autopair \
  Aloxaf/fzf-tab \
  Eloquencere/zsh-goto-cli
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

# Syntax highlighting needs to load LAST
zinit ice wait'1' lucid silent compile
zinit light zdharma-continuum/fast-syntax-highlighting

# autoload -Uz colors && colors

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-pad 5
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:file:*' command 'fd --hidden --exclude .git'
zstyle ':fzf-tab:directory:*' command 'fd --type=d --hidden --exclude .git'
zstyle ':fzf-tab:complete:(cd|ls|touch):*' fzf-preview '[[ -d $realpath ]] && eza --oneline --group-directories-first --color=always --icons=always --all $realpath'
zstyle ':fzf-tab:complete:((cp|mv|rm|nvim|bat|delta):argument-rest|kate:*)' fzf-preview 'bat --color=always -- $realpath 2>/dev/null || eza --oneline --color=always --icons=always --all -- $realpath'

# Shell integrations
eval "$(starship init zsh)"

# Lazy-load the rest on first prompt
autoload -Uz add-zsh-hook
function __lazy_shell_tools {
    eval "$(fzf --zsh)"
    eval "$(atuin init zsh --disable-ctrl-r --disable-up-arrow)"
    eval "$(zoxide init --cmd cd zsh)"
    eval "$(mise activate zsh)"
    add-zsh-hook -d precmd __lazy_shell_tools
}
add-zsh-hook precmd __lazy_shell_tools

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

