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
export PYENV_ROOT="$XDG_DATA_HOME/.pyenv"
export PATH="$PYENV_ROOT/bin":$PATH
source <(pyenv init -)

# Rust
# export PATH=$HOME/.cargo/bin:$PATH

# Questasim
# export PATH="$TOOLS_HOME/Mentor_Graphics/questasim/linux_x86_64":$PATH
# export PATH="$TOOLS_HOME/Mentor_Graphics/questasim/RUVM_2021.2":$PATH
# export LM_LICENSE_FILE="$XDG_DATA_HOME/questasim/license.dat":$LM_LICENSE_FILE
