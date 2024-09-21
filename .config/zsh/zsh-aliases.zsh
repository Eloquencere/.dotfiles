# confirm before overwriting something
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# Better readable format
alias free="free -m" # show sizes in MB

# Basic tools
alias n=nvim
alias neofetch=fastfetch
alias py=python

# Better command line utils
alias ls="eza --color=always --icons=always --git"
alias tree="ls --tree --smart-group --git-ignore"
alias fd="fd --color=always"
alias cat=bat
alias grep=rg
alias df=duf
alias speedtest=speedtest-rs
alias diff="delta --dark --side-by-side"
alias ps="procs --tree"
alias cheat="cheat --colorize"
alias du="dust --reverse --force-colors --no-percent-bars"
alias zellij="zellij -l welcome"

