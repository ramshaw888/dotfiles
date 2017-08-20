# Path to your oh-my-zsh installation.
export ZSH=/Users/aaron/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/opt/local/bin:/opt/local/sbin:/Users/aaron/.cabal/bin:/Applications/ghc-7.8.4.app/Contents/bin:/usr/local/Cellar/coreutils/8.23_1/libexec/gnubin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/texbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
alias cse='ssh aram150@cse.unsw.edu.au'
alias vcse='vim scp://aram150@cse.unsw.edu.au/'
alias csex='ssh -X aram150@login.cse.unsw.edu.au'
alias tw='open -a "TextWrangler"'
alias subl='open -a "Sublime Text"'
alias unsw='cd /Users/Aaron/UNSW'
alias 3141='cd /Users/Aaron/UNSW/3141'
alias 4128='cd /Users/Aaron/UNSW/4128'
alias 3231='cd /Users/Aaron/UNSW/3231'
alias 3821='cd /Users/Aaron/UNSW/3821'
alias 3421='cd /Users/Aaron/UNSW/cs3421'
alias 3431='cd /Users/Aaron/UNSW/cs3431'
alias 4920='cd /Users/Aaron/UNSW/cs4920'
alias 9447='cd /Users/Aaron/UNSW/cs9447'
alias gs='git status'
alias gl='git log'
alias gd='git diff'
alias gc='git checkout'
alias gamend='git add --all; git commit --amend'

alias g++='/usr/local/Cellar/gcc/4.9.2_1/bin/g++-4.9'

# Add GHC 7.8.4 to the PATH, via http://ghcformacosx.github.io/
export GHC_DOT_APP="/Applications/ghc-7.8.4.app"
if [ -d "$GHC_DOT_APP" ]; then
    export PATH="${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi

# MacPorts Installer addition on 2014-04-21_at_15:46:17: adding an appropriate PATH variable for use with MacPorts.
# export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.  

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# AWS autocomplete
source /usr/local/share/zsh/site-functions/_aws

export PATH="$HOME/.node/bin:$PATH"

export PATH="$HOME/.npm-packages/bin:$PATH"

alias npm-exec='PATH=$(npm bin):$PATH'

export PATH="$PATH:`yarn global bin`"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
