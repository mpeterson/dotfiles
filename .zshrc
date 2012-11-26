# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="blinks"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git battery django git pip python taskwarrior virtualenvwrapper vi-mode svn)

source $ZSH/oh-my-zsh.sh

alias ls="ls -l"

# Need to make a function instead of alias because we want to use
# setopt no_complete_aliases which expands aliases to their commands
# Python script can be found at https://github.com/mpeterson/toolbox
t(){
  python ~/src/toolbox/taskwarrior/top-level-tasks.py "$@"
}
compdef _task t=task

# Some sane git defaults
if [ $(command -v 'git') ]
then
  git config --global color.ui auto
  git config --global color.diff auto
  git config --global core.excludesfile "$HOME/.gitignore"
  git config --global alias.recent "reflog -20 --date=relative"
  git config --global alias.ci commit
  git config --global alias.st status
  git config --global alias.co checkout
fi

# Automatically load TMUX
if [ "$PS1" != "" -a "${STARTED_TMUX:-x}" = x -a "${SSH_TTY:-x}" != x ]
then
        STARTED_TMUX=1; export STARTED_TMUX
        sleep 1
        ( (tmux has-session -t remote && tmux attach-session -t remote) || (tmux new-session -s remote) ) && exit 0
        echo "tmux failed to start"
fi

