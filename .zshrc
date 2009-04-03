# Check if .zsh exists, otherwise create it.
if [[ ! -d "$HOME/.zsh" ]]; then
  /bin/mkdir "$HOME/.zsh"
  echo "Directory $HOME/.zsh created!"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Enable Cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# load colors
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi

# powerful globbing
setopt extendedglob
setopt NO_BEEP

#alias
alias root='sudo -s'
alias ls='ls -lh'
alias dir="ls"
alias md='mkdir'
alias rd='rm -r'
alias ..='cd ..'
alias ...='cd ../..'
alias vi='vim'
alias grep='grep --colour'
alias myip="wget -O - -q myip.dk |grep '\"Box\"' | egrep -o '[0-9.]+'"

#complex alias
wgz(){
  wget -O- "$*"|tar xzf -
}

wbz(){
  wget -O- "$*"|tar xjf -
}

# Python
PYTHONSTARTUP=$HOME/.pythonrc

# Behave UTF-8
export LANG=en_US.UTF-8
stty erase 
bindkey "[3~" delete-char
set meta-flag on
set input-meta on
set output-meta on
set convert-meta off

# mapping for tab, want to autocomplete by prefix
bindkey '^i' expand-or-complete-prefix

# mapping for arrow keys
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

# mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word

# allow the use of the Home/End keys
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

# allow the use of the Delete/Insert keys
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert

# Show man page of the current command
autoload run-help
bindkey "" run-help

# Do incremental search 
bindkey "^R" history-incremental-search-backward

case $TERM in
  xterm*)
    precmd(){
      local git_branch
      git_branch=`git symbolic-ref HEAD 2>/dev/null|awk '{sub(/^refs\/heads\//, "", $1); print " ("$1")"}'`
      local UC=$fg_bold[white]              # user's color
      [ $UID -eq "0" ] && UC=$fg_bold[red]  # root's color

      PROMPT="%{$fg_bold[blue]%}%n%{$UC%}@%{$fg_bold[blue]%}%m %~$git_branch%{$UC%}%(!.#.\$) %{$reset_color%}"
      print -Pn "\e]0;%n@%m: %~\a"
    }
    preexec(){
      print -nR $'\033]0;'$1$'\a'
    }
  ;;
  screen*)
    precmd(){
      local git_branch
      git_branch=`git symbolic-ref HEAD 2>/dev/null|awk '{sub(/^refs\/heads\//, "", $1); print " ("$1")"}'`
      local UC=$fg_bold[white]              # user's color
      [ $UID -eq "0" ] && UC=$fg_bold[red]  # root's color

      PROMPT="%{$fg_bold[blue]%}%n%{$UC%}@%{$fg_bold[blue]%}%m %~$git_branch%{$UC%}%(!.#.\$) %{$reset_color%}"
      print -Pn "\e]0;%n@%m: %~\a"
    }
    preexec(){
      print -nR $'\033]0;'$1$'\a'
    }
    print -nR $'\033k'$USER$'\033'\\
  ;;


  *)
    if [[ "$terminfo[colors]" -ge 8 ]]; then
      precmd(){
        local git_branch
        git_branch=`git symbolic-ref HEAD 2>/dev/null|awk '{sub(/^refs\/heads\//, "", $1); print " ("$1")"}'`
        local UC=$fg_bold[white]              # user's color
        [ $UID -eq "0" ] && UC=$fg_bold[red]  # root's color

        PROMPT="%{$fg_bold[blue]%}%n%{$UC%}@%{$fg_bold[blue]%}%m %~$git_branch%{$UC%}%(!.#.\$) %{$reset_color%}"
      }
    else
      precmd(){ PROMPT="%n@%m: %~$git_branch%(!.#.\$)" }
    fi
  ;;
esac

# Auto-screen invocation. see: http://taint.org/wk/RemoteLoginAutoScreen
# if we're coming from a remote SSH connection, in an interactive session
# then automatically put us into a screen(1) session.   Only try once
# -- if $STARTED_SCREEN is set, don't try it again, to avoid looping
# if screen fails for some reason.
if [ "$PS1" != "" -a "${STARTED_SCREEN:-x}" = x -a "${SSH_TTY:-x}" != x ]
then
  STARTED_SCREEN=1 ; export STARTED_SCREEN
  [ -d $HOME/lib/screen-logs ] || mkdir -p $HOME/lib/screen-logs
  sleep 1
  screen -xRR -U -S screen && exit 0
  # normally, execution of this rc script ends here...
  echo "Screen failed! continuing with normal bash startup"
fi
# [end of auto-screen snippet]

export PATH=$HOME/installed/bin:/opt/local/bin:/opt/local/sbin:$PATH

if [[ -f ~/.zshrc_personal ]]; then
  source ~/.zshrc_personal
fi
