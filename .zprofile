# Profile file. Runs on login. Environment variables are here

# Clean-up
export ZDOTDIR="$HOME/.config/zsh"
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export TOOLS_HOME=$HOME/Tools
export DOTFILES_HOME=$HOME/.dotfiles

# Sourcing local changes
source $DOTFILES_HOME/local/zprofile-local.sh
