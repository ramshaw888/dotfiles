export VISUAL='nvim'
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"
export GOPATH=$HOME/code/go

# All non golang repos in ~/code
export CDPATH=.:$HOME/code

# GOPATH stuff
export CDPATH=$CDPATH:$GOPATH/src/github.com:$GOPATH/src/golang.org:$GOPATH/src

alias vim="$VISUAL"

alias ls='ls -GFh'
alias gs='git status'
alias gd='git diff'
alias gc='git checkout'
alias gl='git log'
alias glo='git log --name-only'
alias gls='git log --pretty=oneline --abbrev-commit'
alias glg='git log --graph --pretty=oneline --abbrev-commit --all'
alias gamend='git add --all; git commit --amend'
alias dev='cd ~/code'
alias vi='vim'
