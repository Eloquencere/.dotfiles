# Profile file. Runs on login. Environment variables are here

# Default path
export EDITOR="nvim"

# 32-bit library path
export LIBRARY_PATH="/usr/lib32":$LIBRARY_PATH
export PATH="$HOME/.local/bin":$PATH

# Base path definitions
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"
export DOTFILES_HOME="$HOME/.dotfiles"
export TOOLS_HOME="$HOME/Tools"

# Starship config
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# fzf modifications
export FZF_DEFAULT_OPTS="--ansi"

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME/rust/rustup"
export RUSTC_WRAPPER="sccache"
export CARGO_HOME="$XDG_DATA_HOME/rust/cargo"
export PATH="$PATH:$CARGO_HOME/bin"

# Python
export PYTHONHISTORY="/dev/null"

# Conan(C/C++)
export CONAN_HOME="$XDG_DATA_HOME/conan"

# LM studio
export PATH="$HOME/.lmstudio/bin":$PATH

# Personal confidential environment variables
if [[ -f "$ZDOTDIR/personal/zprofile.zsh" ]]; then
    source "$ZDOTDIR/personal/zprofile.zsh"
fi

# Plugin manager for zsh
if [[ ! -d $ZINIT_HOME ]]; then
    git clone https://github.com/zdharma-continuum/zinit.git $ZINIT_HOME
fi

