setopt nobeep
setopt correct
setopt glob_dots
setopt no_clobber
setopt no_flow_control
setopt extended_glob
setopt hist_ignore_all_dups
setopt interactive_comments

source "$ZINIT_HOME/zinit.zsh"

fpath+=$ZDOTDIR/completion
# nocd stops zinit from cd-ing into the plugin dir when running atinit.
# If prompt still shows wrong dir on startup, drop nocd and instead
# move compinit out of atinit to the end of this file (plain autoload).
zinit wait lucid compile nocd atinit"
    [[ -r $ZINIT_HOME/.zcompdump ]] && compinit -C || { zicompinit; zicdreplay; }
    _comps[delta]=_files
" for zsh-users/zsh-completions

zinit wait lucid compile for \
    jeffreytse/zsh-vi-mode \
    hlissner/zsh-autopair \
    Eloquencere/zsh-goto-cli

zinit wait lucid compile atload'
    # Wrap fzf-tab-complete to force fast-syntax-highlighting to re-apply
    # syntax colors after fzf-tab exits (fixes command color loss when
    # pressing Esc to cancel a completion preview).
    typeset -g _orig_ftc=${widgets[fzf-tab-complete]#*:}
    function _wrap_ftc() {
        ${_orig_ftc} "$@"
        typeset -g _ZSH_HIGHLIGHT_PRIOR_BUFFER=
    }
    zle -N fzf-tab-complete _wrap_ftc
' for Aloxaf/fzf-tab

zinit wait lucid compile for \
    zdharma-continuum/fast-syntax-highlighting

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-pad 5
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:complete:just:*' fzf-preview 'just --color always --show $word 2>/dev/null'
zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d $realpath ]] && eza --all --oneline --group-directories-first --color=always --icons=always -- $realpath || bat --color=always -- $realpath 2>/dev/null'

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

# Belt-and-suspenders: ensure promptsubst is globally on.  Starship's init
# sets it, but an async zinit zle -F firing during the first PROMPT eval can
# momentarily catch it off, causing the raw $() string to appear.
setopt promptsubst

function zvm_config() {
    ZVM_INIT_MODE=sourcing # github.com/jeffreytse/zsh-vi-mode#initialization-mode
}
function zvm_after_init() {
	zvm_bindkey viins '^r' atuin-search
	zvm_bindkey viins '^p' atuin-up-search
    zvm_bindkey viins '^b' clear-screen
}

# Fix prompt duplication when switching between zellij/tmux panes.
if [[ -n "$ZELLIJ" ]]; then
    TRAPWINCH() {
        zle .reset-prompt &> /dev/null
    }
fi

