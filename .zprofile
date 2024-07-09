# Profile file. Runs on login. Environment variables are here

# Clean-up
export ZDOTDIR="$HOME/.config/zsh"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export TOOLS_HOME="$HOME/Tools"
export DOTFILES_HOME="$HOME/.dotfiles"

# History settings
export HISTTIMEFORMAT="[%F %T] "

# ------ Local ------

# Starship
export STARSHIP_CONFIG=${XDG_CONFIG_HOME}/starship/starship.toml

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin":$PATH

# Rust
# export PATH=$HOME/.cargo/bin:$PATH
