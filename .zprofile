# Profile file. Runs on login. Environment variables are here

# Setup System-manager
export PATH="/run/system-manager/sw/bin/:${PATH}"


# Default path
export EDITOR="nvim"

# Base path definitions
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export TOOLS_HOME="$HOME/Tools"
export DOTFILES_HOME="$HOME/.dotfiles"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Starship config
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# fzf modifications
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git --color=always"
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git --color=always"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/rust/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rust/rustup"
export RUSTC_WRAPPER="$CARGO_HOME/bin/sccache"

# Conan(C/C++)
export CONAN_HOME="$XDG_DATA_HOME/conan"

# 32-bit library path
export LIBRARY_PATH="/usr/lib32":$LIBRARY_PATH
export PATH="$HOME/.local/bin":$PATH

# Personal confidential environment variables
if [[ -f "$ZDOTDIR/personal/zprofile.zsh" ]]; then
    source "$ZDOTDIR/personal/zprofile.zsh"
fi

# Plugin manager for zsh
[[ ! -d "$XDG_DATA_HOME/zinit-pkgmngr" ]] && git clone https://github.com/zdharma-continuum/zinit.git "$XDG_DATA_HOME/zinit-pkgmngr"

