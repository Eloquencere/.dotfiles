setopt nobeep
setopt correct
setopt glob_dots
setopt extended_glob
setopt no_clobber
setopt no_flow_control
setopt hist_ignore_all_dups
setopt interactive_comments

source "$ZINIT_HOME/zinit.zsh"

ZINIT[ZCOMPDUMP_PATH]="$XDG_CACHE_HOME/zinit/.zcompdump"

fpath+=$ZDOTDIR/completion
zinit wait lucid compile nocd atinit"
    [[ -r ${ZINIT[ZCOMPDUMP_PATH]} ]] && compinit -C -d "$ZINIT[ZCOMPDUMP_PATH]" || { zicompinit; zicdreplay; }
    _comps[delta]=_files
" for zsh-users/zsh-completions

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
    jeffreytse/zsh-vi-mode \
    hlissner/zsh-autopair \
    Eloquencere/zsh-goto-cli \
    zdharma-continuum/fast-syntax-highlighting

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-pad 5
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d $realpath ]] && eza --all --oneline --group-directories-first --color=always --icons=always -- $realpath || bat --color=always -- $realpath 2>/dev/null'

function __lazy_shell_tools {
    eval "$(starship init zsh)"; prompt_starship_precmd

    # os_info shells out to lsb_release (~16ms) on every repaint, and the symbol
    # never changes for a given machine. Compute it once; starship.toml renders
    # it through the env_var module rather than re-running the os module.
    export STARSHIP_OS_ICON="$(starship module os 2>/dev/null)"

    typeset -g _starship_prompt_tmpl=$PROMPT _starship_rprompt_tmpl=$RPROMPT
    __prompt_starship_render() {
        PROMPT="${(e)_starship_prompt_tmpl}"
        RPROMPT="${(e)_starship_rprompt_tmpl}"
    }
    add-zsh-hook precmd __prompt_starship_render

    eval "$(atuin init zsh --disable-ctrl-r --disable-up-arrow)"
    eval "$(zoxide init --cmd cd zsh)"
    eval "$(mise activate zsh)"
    __prompt_starship_render
    add-zsh-hook -d precmd __lazy_shell_tools
}
add-zsh-hook precmd __lazy_shell_tools

function zvm_config() {
    ZVM_INIT_MODE=sourcing # github.com/jeffreytse/zsh-vi-mode#initialization-mode
}
function zvm_after_init() {
	zvm_set_cursor "$(zvm_cursor_style "$ZVM_INSERT_MODE_CURSOR")"
	zvm_bindkey viins '^r' atuin-search
	zvm_bindkey viins '^p' atuin-up-search
    zvm_bindkey viins '^b' clear-screen
}

source "$ZDOTDIR/zsh-aliases.zsh"
source "$ZDOTDIR/zsh-functions.zsh"

# Personal confidential variables
if [[ -f "$ZDOTDIR/personal/zshrc.zsh" ]]; then
    source "$ZDOTDIR/personal/zshrc.zsh"
fi

