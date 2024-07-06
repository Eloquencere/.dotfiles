# Zsh-Vi-Mode
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode"
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
# bindkey '^p' line-up-or-search
# bindkey '^n' line-down-or-search"

# fzf-tab
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons=always --all --long --no-filesize --no-user --no-time --no-permissions $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons=always --all --long --no-filesize --no-user --no-time --no-permissions $realpath'

# Shell integrations
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
