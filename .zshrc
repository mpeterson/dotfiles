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

# Aliases
alias ls="`whence ls` -l" # Use whence so we don't overwrite the previous alias

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

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
