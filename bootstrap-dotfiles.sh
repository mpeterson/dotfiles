#!/usr/bin/env bash

### CONFIG ###
DOTFILES_GIT="${DOTFILES_GIT:-https://github.com/mpeterson/dotfiles.git}"
##############

set -x

function warn_prerequisites() {
  echo "Error: Pre requisites failed installation"
  exit 1
}

trap warn_prerequisites EXIT

# Function to prepend sudo if necessary
prepend_sudo_if_needed() {
  local command="$1"
  if [ "$EUID" -ne 0 ] && command -v sudo &> /dev/null; then
    echo "sudo $command"
  else
    echo "$command"
  fi
}

# Detect the system's package installer
if command -v apt-get &> /dev/null; then
  INSTALL=$(prepend_sudo_if_needed "apt-get -y install")
  export DEBIAN_FRONTEND=noninteractive
elif command -v dnf &> /dev/null; then
  INSTALL=$(prepend_sudo_if_needed "dnf -y install")
elif command -v brew &> /dev/null; then
  INSTALL="brew install"  # No sudo needed for brew
else
  echo "Error: Your OS is not supported :(" >&2
  exit 1
fi

# test if command exists
function check() {
  echo "Checking for ${1} .."
  if type -f "${1}" >/dev/null 2>&1; then
    return 1
  else
    echo "Installing ${1}"
    return 0
  fi
}

set -e

echo "Installing pre-requisites"
check git && $INSTALL git
check zsh && $INSTALL zsh
check wget && $INSTALL wget
check python3 && $INSTALL python3

# A bit more complex for neovim
if [ -n "$apt" ]; then
  $INSTALL neovim python3-neovim
elif [ -n "$dnf" ]; then
  $INSTALL epel-release
  $INSTALL neovim
  $INSTALL pip
  python3 -m pip install --user --upgrade pynvim typing_extensions
elif [ -n "$brew" ]; then
  $INSTALL neovim
  python3 -m pip install --user --upgrade --break-system-packages pynvim typing_extensions
fi

set +e

trap - EXIT

git clone --bare "$DOTFILES_GIT" "$HOME/.cfg"
function dotfiles() {
  /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "$@"
}
# We want that only dotfiles will exist in a bootstrapped $HOME
dotfiles config core.sparseCheckout true
echo "/.*" > "$HOME/.cfg/info/sparse-checkout"
echo "\!/.gitignore" >> "$HOME/.cfg/info/sparse-checkout"
echo "\!/.github" >> "$HOME/.cfg/info/sparse-checkout"
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out config."
else
  echo "Backing up pre-existing dot files."
  mkdir -p .dotfiles-backup
  dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi
dotfiles checkout
dotfiles config status.showUntrackedFiles no
# remove the backup folder only if empty
rmdir .dotfiles-backup 2>/dev/null

# Install zprezto (to update after run zprezto-update
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
pushd "${ZDOTDIR:-$HOME}/.zprezto"
# continue with prezto-contrib
git clone --recurse-submodules https://github.com/belak/prezto-contrib contrib
popd

# Install vim-plug for nvim and install all plugins at once
mkdir -p "$HOME/.local/share/nvim/site/autoload" && \
wget -q --show-progress -O "$HOME/.local/share/nvim/site/autoload/plug.vim" \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
nvim +PlugUpdate +PlugClean! +qall!

set +x

cat << EOF
Run the following command to replace the current shell with zsh for the all the sessions:

chsh -s zsh

And/Or run the following command to replace the current shell with zsh until exited:

exec zsh -l

EOF
