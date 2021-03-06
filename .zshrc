#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

### 0. Optional startup profiling
#
# based on http://stackoverflow.com/questions/4351244
#
if [[ -n $ZSH_ENABLE_PROFILE ]]; then
  # start zsh profiling
  zmodload zsh/datetime
  # set the trace prompt to include seconds, nanoseconds, script name and line
  # number
  setopt promptsubst
  PS4='+$EPOCHREALTIME %N:%i> '
  # save file stderr to file descriptor 3 and redirect stderr (including trace
  # output) to a file with the script's PID as an extension
  STARTLOG=/tmp/startlog.$$
  exec 3>&2 2>$STARTLOG
  # set options to turn on tracing and expansion of commands contained in the
  # prompt
  setopt xtrace prompt_subst
  zmodload zsh/zprof
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Enable History Incremental Search
bindkey -M viins '^R' history-incremental-search-backward

# Load aliases
if [[ -d "${ZDOTDIR:-$HOME}/.zalias.d" ]]; then
  for file in "${ZDOTDIR:-$HOME}/.zalias.d/"*; do
      source "$file"
  done
fi

# Load local aliases
if [[ -s "${ZDOTDIR:-$HOME}/.zalias.local" ]]; then
  source "${ZDOTDIR:-$HOME}/.zalias.local"
fi

# Some sane git defaults
if [ $(command -v 'git') -a -z "$(git config user.name)" ]
then
  echo 'Seems you have git installed'
  echo 'What username do you want to use for git?'
  read git_user
  echo 'And which mail should we use?'
  read git_mail
  if [ -n "$git_user" -a -n "$git_mail" ]
  then
      git config --global color.ui auto
      git config --global color.diff auto
      git config --global core.excludesfile "$HOME/.gitignore"
      git config --global alias.recent "reflog -20 --date=relative"
      git config --global alias.ci commit
      git config --global alias.st status
      git config --global alias.co checkout
      git config --global core.editor `which $EDITOR`
      git config --global user.name "$git_user"
      git config --global user.email "$git_mail"
  fi
fi

## 0. End startup profiling
#

if [[ -n $ZSH_ENABLE_PROFILE ]]; then
  # turn off tracing
  unsetopt xtrace
  # restore stderr to the value saved in FD 3
  exec 2>&3 3>&-
  echo >>$STARTLOG
  zprof >>$STARTLOG
  echo "Start log saved in $STARTLOG"
fi

#zprof
