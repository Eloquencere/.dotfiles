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
alias mux=tmuxp

# Better command line utils
alias ls="eza --color=always --icons=always --git"
alias tree="ls --tree --git-ignore"
alias find=fd
alias cat=bat
alias grep=rg
alias df=duf
alias speedtest=speedtest-rs
alias delta="delta --dark --side-by-side"
alias ps="procs --tree --sortd cpu"
alias cheat="cheat --colorize"
