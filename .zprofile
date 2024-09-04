# Profile file. Runs on login. Environment variables are here

# Default path
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"
export TERM="xterm-256color"

# Base definitions
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export TOOLS_HOME="$HOME/Tools"
export DOTFILES_HOME="$HOME/.dotfiles"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# fzf modifications
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git --color=always"
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git --color=always"

# Starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/rust/.cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rust/.rustup"
export RUSTC_WRAPPER=$CARGO_HOME/bin/sccache

# Conan(C/C++)
export CONAN_HOME="$XDG_DATA_HOME/conan"

# Initialising completions directory
fpath=($ZDOTDIR/completion $fpath)

# Confidential environment variables
[[ -f "$ZDOTDIR/.confidential/zprofile.zsh" ]] && source "$ZDOTDIR/.confidential/zprofile.zsh"

# Plugin manager for zsh
[[ ! -d "$ZDOTDIR/zinit" ]] && git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.config/zsh/zinit"
# Package manager for tmux
[[ ! -d "$XDG_CONFIG_HOME/tmux/plugins" ]] && git clone https://github.com/tmux-plugins/tpm.git "$HOME/.config/tmux/plugins/tpm"
# Themes for alacritty
[[ ! -d "$XDG_CONFIG_HOME/alacritty/themes" ]] && git clone https://github.com/alacritty/alacritty-theme.git "$HOME/.config/alacritty/themes"
