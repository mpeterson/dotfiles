#!/usr/bin/env bash

### CONFIG ###
DOTFILES_GIT="${DOTFILES_GIT:-https://github.com/mpeterson/dotfiles.git}"
##############

# Enable debug mode
set -euxo pipefail

# Function to handle prerequisites failure
warn_prerequisites() {
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
apt=$(command -v apt-get || true)
dnf=$(command -v dnf || true)
brew=$(command -v brew || true)
if [ -n "$apt" ]; then
  INSTALL=$(prepend_sudo_if_needed "apt-get -y install")
  export DEBIAN_FRONTEND=noninteractive
elif [ -n "$dnf" ]; then
  INSTALL=$(prepend_sudo_if_needed "dnf -y install")
elif [ -n "$brew" ]; then
  INSTALL="brew install"
else
  echo "Error: Your OS is not supported :(" >&2
  exit 1
fi

# Function to check and install a command if it doesn't exist
check_and_install() {
  local cmd="$1"
  echo "Checking for $cmd .."
  if ! command -v "$cmd" &>/dev/null; then
    echo "Installing $cmd"
    $INSTALL "$cmd"
  fi
}

# Install prerequisites
echo "Installing pre-requisites"
check_and_install git
check_and_install zsh
check_and_install wget
check_and_install python3

# Install neovim with additional packages + plugins from dotfiles
install_neovim() {
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

  if ! command -v "nvim" &>/dev/null; then
     echo "Installation of neovim failed"
     return 1
  fi
  
  # Install vim-plug for nvim and install all plugins at once
  mkdir -p "$HOME/.local/share/nvim/site/autoload" && \
  wget -q --show-progress -O "$HOME/.local/share/nvim/site/autoload/plug.vim" \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
  nvim +PlugUpdate +PlugClean! +qall!
}

trap - EXIT

# Clone dotfiles repository
git clone --bare "$DOTFILES_GIT" "$HOME/.cfg"
dotfiles() {
  /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "$@"
}
dotfiles config core.sparseCheckout true
echo "/.*" > "$HOME/.cfg/info/sparse-checkout"
echo "\!/.gitignore" >> "$HOME/.cfg/info/sparse-checkout"
echo "\!/.github" >> "$HOME/.cfg/info/sparse-checkout"
dotfiles checkout || {
  echo "Backing up pre-existing dot files."
  mkdir -p .dotfiles-backup
  dotfiles checkout 2>&1 | egrep "\s+\." | awk '{print $1}' | xargs -I{} mv {} .dotfiles-backup/{}
  dotfiles checkout
}
dotfiles config status.showUntrackedFiles no

# Remove .doffiles-backup if empty
rmdir .dotfiles-backup 2>/dev/null || true

# Install zprezto (in the future, zprezto-update updates prezto)
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
(
  cd "${ZDOTDIR:-$HOME}/.zprezto"
  git clone --recurse-submodules https://github.com/belak/prezto-contrib contrib
)

install_neovim || true

set +x

cat << EOF
Run the following command to replace the current shell with zsh for the all the sessions:

chsh -s zsh

And/Or run the following command to replace the current shell with zsh until exited:

exec zsh -l

EOF
