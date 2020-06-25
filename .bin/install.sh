#!/usr/bin/env bash

### CONFIG ###
DOTFILES_GIT=git@github.com:mpeterson/dotfiles.git
##############


apt=$(command -v apt)
dnf=$(command -v dnf)
yum=$(command -v yum)
brew=$(command -v brew)

## Detect the systems installer
if [ -n "$apt" ]; then
  INSTALL='sudo apt-get -y install'
elif [ -n "$dnf" ]; then
  INSTALL='sudo dnf -y install'
elif [ -n "$yum" ]; then
  INSTALL='sudo yum -y install'
elif [ -n "$brew" ]; then
  INSTALL='brew install'
else
  echo "Error: Your OS is not supported :(" >&2;
  exit 1;
fi

## test if command exists
check () {
  echo "Checking for ${1} .."
  if type -f "${1}" > /dev/null 2>&1; then
    return 1
  else
    echo "Installing ${1}"
    return 0
  fi
}

echo "Installing pre-requisites"
check git && $INSTALL git
check zsh && $INSTALL zsh
check wget && $INSTALL wget
check python2 && $INSTALL python2
check python3 && $INSTALL python3

# A bit more complex for neovim
if [ -n "$apt" ]; then
  $INSTALL neovim python3-neovim python-neovim
elif [ -n "$dnf" ]; then
  $INSTALL neovim python3-neovim python-neovim
elif [ -n "$yum" ]; then
  $INSTALL https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  $INSTALL neovim python3-neovim python2-neovim
elif [ -n "$brew" ]; then
  $INSTALL neovim
  sudo python2 -m pip install --upgrade pynvim
  sudo python3 -m pip install --upgrade pynvim
fi

git clone --bare "$DOTFILES_GIT" "$HOME/.cfg"
function config {
 /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "$@"
}
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no


# Install zprezto, with version pinning
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
pushd "${ZDOTDIR:-$HOME}/.zprezto"
git checkout ff91c8d410df3e6141248474389051c7ddcaf80a
popd

# Install vim-plug for nvim
sh -c 'curl -fLo "${$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugUpdate +PlugClean! +qall