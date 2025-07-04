# confirm before overwriting something
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# Better readable format
alias free="free -m" # show sizes in MB

# Basic tools
alias n=nvim
alias py=python3
alias py2=python2

# Better command line utils
alias ls="eza --color=always --icons=always --git --group-directories-first"
alias tree="ls --tree --smart-group --git-ignore"
alias fd="fd --color=always"
alias find=fd
alias cat=bat
alias diff="delta --dark --side-by-side "
alias grep=rg
alias df=duf
alias neofetch=fastfetch
alias cheat="cheat --colorize"

# Fixing Completions
compdef delta=rm
compdef bat=nvim

