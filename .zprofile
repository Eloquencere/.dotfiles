# Profile file. Runs on login. Environment variables are here

# Default path
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"

# Clean-up
export ZDOTDIR="$HOME/.config/zsh"
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export TOOLS_HOME=$HOME/Tools

# Starship config file
export STARSHIP_CONFIG=${XDG_CONFIG_HOME}/starship/starship.toml

# Rust
# export PATH=$HOME/.cargo/bin:$PATH

# QuestaSim
export PATH="$TOOLS_HOME/Mentor_Graphics/questasim/linux_x86_64":$PATH
export PATH="$TOOLS_HOME/Mentor_Graphics/questasim/RUVM_2021.2":$PATH
export LM_LICENSE_FILE="$XDG_DATA_HOME/QuestaSim/license.dat":$LM_LICENSE_FILE

# Symbiyosys
export PATH="$TOOLS_HOME/YosysHQ/oss-cad-suite/bin":$PATH

# Vivado
source $TOOLS_HOME/Xilinx/Vivado/2024.1/settings64.sh
source $TOOLS_HOME/Xilinx/Vitis/2024.1/settings64.sh

