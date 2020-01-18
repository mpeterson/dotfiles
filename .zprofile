#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
  export LC_ALL='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

export GOPATH=$HOME/go

# Set the list of directories that Zsh searches for programs.
path=(
  $HOME/bin
  /usr/local/{bin,sbin}
  $GOPATH/bin
  $path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$USER"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
  mkdir -p "$TMPPREFIX"
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


