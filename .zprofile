# Profile file. Runs on login. Environment variables are here

# Default path
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"
export TERM="xterm-256color"

# Clean-up
export TOOLS_HOME="$HOME/Tools"
export DOTFILES_HOME="$HOME/.dotfiles"

# zsh initialisation
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# fzf modifications
export FZF_DEFAULT_COMMAND="fd --color=always --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --color=always --type=d --hidden --strip-cwd-prefix --exclude .git"

# Starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/rust/.cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rust/.rustup"
export RUSTC_WRAPPER=$CARGO_HOME/bin/sccache

# Conan(C/C++)
export CONAN_HOME="$XDG_DATA_HOME/conan"
