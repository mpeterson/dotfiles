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

# completion options
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
	'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions
# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
# add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command'
# all /etc/hosts hostnames are in autocomplete
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}')
# filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro'
# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns \
	adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
	named news nfs nfsnobody nobody nscd ntp operator pcap postgres radvd \
	rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs avahi-autoipd \
	avahi backup messagebus beagleindex debian-tor dhcp dnsmasq fetchmail \
	firebird gnats haldaemon hplip irc klog list man cupsys postfix \
	proxy syslog www-data mldonkey sys snort
# ssh completion
zstyle ':completion:*:scp:*' tag-order \
	files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
	files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
	users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
	hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show

# alias
# #####
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
export PYTHONSTARTUP=$HOME/.pythonrc

# pager
export PAGER='less'

# editor
export EDITOR='vim'

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
bindkey "^N" run-help

# Do incremental search 
bindkey "^R" history-incremental-search-backward

case $TERM in
  xterm*)
    precmd(){
      local git_branch
      git_branch=`git symbolic-ref HEAD 2>/dev/null|awk '{sub(/^refs\/heads\//, "", $1); print " ("$1")"}'`
      python_virtualenv=`basename $VIRTUAL_ENV 2>/dev/null|awk '/./ {print "["$1"] "}'`
      local UC=$fg_bold[white]              # user's color
      [ $UID -eq "0" ] && UC=$fg_bold[red]  # root's color

      PROMPT="%{$fg_bold[red]%}$python_virtualenv%{$fg_bold[blue]%}%n%{$UC%}@%{$fg_bold[blue]%}%m %~$git_branch%{$UC%}%(!.#.\$) %{$reset_color%}"
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
      python_virtualenv=`basename $VIRTUAL_ENV 2>/dev/null|awk '/./ {print "["$1"] "}'`
      local UC=$fg_bold[white]              # user's color
      [ $UID -eq "0" ] && UC=$fg_bold[red]  # root's color

      PROMPT="%{$fg_bold[red]%}$python_virtualenv%{$fg_bold[blue]%}%n%{$UC%}@%{$fg_bold[blue]%}%m %~$git_branch%{$UC%}%(!.#.\$) %{$reset_color%}"
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
        python_virtualenv=`basename $VIRTUAL_ENV 2>/dev/null|awk '/./ {print "["$1"] "}'`
        local UC=$fg_bold[white]              # user's color
        [ $UID -eq "0" ] && UC=$fg_bold[red]  # root's color

        PROMPT="%{$fg_bold[red]%}$python_virtualenv{$fg_bold[blue]%}%n%{$UC%}@%{$fg_bold[blue]%}%m %~$git_branch%{$UC%}%(!.#.\$) %{$reset_color%}"
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
