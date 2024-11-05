# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
if [[ -d "${ZDOTDIR:-$HOME}/.zshrc.d" ]]; then
  for file in "${ZDOTDIR:-$HOME}/.zshrc.d/"*; do
      source "$file"
  done
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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
