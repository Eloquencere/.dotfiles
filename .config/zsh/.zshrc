setopt nobeep
setopt correct
setopt auto_cd
setopt glob_dots
setopt no_clobber
setopt no_flow_control
setopt extended_glob
setopt hist_ignore_all_dups
setopt interactive_comments

# This does work
# export HERMES_HOME="$XDG_CONFIG_HOME/hermes"

source "$ZINIT_HOME/zinit.zsh"

zinit wait lucid compile for \
    jeffreytse/zsh-vi-mode \
    hlissner/zsh-autopair \
    Aloxaf/fzf-tab \
    Eloquencere/zsh-goto-cli \
    zdharma-continuum/fast-syntax-highlighting

fpath+=$ZDOTDIR/completion
zinit wait lucid compile atinit"[[ -r $ZINIT_HOME/.zcompdump ]] && compinit -C || { zicompinit; zicdreplay; }" for \
    zsh-users/zsh-completions
# zinit wait lucid compile for \
#     atinit"zicompinit; zicdreplay" \
#     zsh-users/zsh-completions
_comps[delta]=_files

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-pad 5
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d $realpath ]] && eza --all --oneline --group-directories-first --color=always --icons=always -- $realpath || bat --color=always -- $realpath 2>/dev/null'

autoload -Uz add-zsh-hook
function __lazy_shell_tools {
    eval "$(starship init zsh)" &> /dev/null
    prompt_starship_precmd  # call directly so first prompt gets starship rendering
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

source "$ZDOTDIR/zsh-aliases.zsh"
source "$ZDOTDIR/zsh-functions.zsh"

function clear-keep-buffer() {
    zle clear-screen
}
zle -N clear-keep-buffer

function zvm_config() {
    ZVM_INIT_MODE=sourcing # github.com/jeffreytse/zsh-vi-mode#initialization-mode
}
function zvm_after_init() {
	zvm_bindkey viins '^r' atuin-search
	zvm_bindkey viins '^p' atuin-up-search
    zvm_bindkey viins '^b' clear-keep-buffer
}

