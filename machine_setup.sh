#!/bin/bash

# Set color constants
RESET="\e[0m"

BOLD="\e[1m"
DIM="\e[2m"
UNDERLINE="\e[4m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"

# Initial feedback
clear
echo "$YELLOW$BOLD Setting up machine...$RESET\n"

# Update the system
echo "$CYAN Updating the core system...$RESET"
if command -v apt-get 2>/dev/null >/dev/null; then
  echo "$CYAN Running apt-get update"
  sudo apt-get update >/dev/null
  echo "$CYAN Running apt-get upgrade"
  sudo apt-get -y upgrade >/dev/null
fi
if command -v pacman 2>/dev/null >/dev/null; then
  echo "$CYAN Running pacman -Syy..."
  sudo pacman -Syy >/dev/null
fi
echo "$RESET$GREEN System successfully updated!$RESET"

# Install functions
ifpacman() {
  if command -v pacman 2>/dev/null >/dev/null; then
    yes | sudo pacman -S $@ > /dev/null
  fi
}
ifapt() {
  if command -v apt 2>/dev/null >/dev/null; then
    sudo apt -y install $@ > /dev/null
  fi
}
ifaptget() {
  if command -v apt-get 2>/dev/null >/dev/null; then
    sudo apt-get -y install $@ > /dev/null
  fi
}

# Install basic tools
echo "$YELLOW Installing curl and wget$RESET"
ifaptget curl
ifaptget wget
ifpacman curl
ifpacman wget
echo "$GREEN Installed curl and wget$RESET\n"

# Install yaourt if available
if command -v pacman 2>/dev/null >/dev/null; then
  echo "$CYAN Try installing yaourt... $RESET"
  sudo touch /etc/pacman.conf
  sudo echo \[archlinuxfr\] >> /etc/pacman.conf
  sudo echo SigLevel = Never >> /etc/pacman.conf
  sudo echo Server = http://repo.archlinux.fr/\$arch >> /etc/pacman.conf
  sudo pacman -Sy yaourt > /dev/null
  echo "$GREEN Installed yaourt$RESET\n"
fi

# Install git
echo "$YELLOW Installing git$RESET"
ifpacman git
ifaptget git
echo "$GREEN Installed git$RESET\n"

# Install zsh
echo "$YELLOW Installing zsh$RESET"
ifpacman zsh
ifaptget zsh
echo "$GREEN Installed zsh$RESET\n"

# Clone my repository in home folder (includes zshrc and vim settings)
echo "$CYAN Download dotfiles into ~$RESET"
cd ~
git init
git remote add origin https://github.com/deniskabana/dotfiles
git fetch origin
git checkout -b master --track origin/master
echo "$GREEN That went well!$RESET\n"

# Install nodejs
echo "$YELLOW Installing nodejs$RESET"
if command -v apt-get 2>/dev/null >/dev/null; then
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  ifaptget nodejs
fi
ifpacman nodejs npm
echo "$GREEN Installed nodejs$RESET\n"

# Install yarn
echo "$YELLOW Installing yarn$RESET"
if command -v apt-get 2>/dev/null >/dev/null; then
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && ifaptget yarn
fi
ifpacman yarn
echo "$GREEN Installed yarn$RESET\n"

# Install pure-prompt
echo "$YELLOW Installing pure-prompt$RESET"
sudo yarn global add pure-prompt >/dev/null
echo "$GREEN Installed pure-prompt$RESET\n"

# Download zsh plugins I use
echo "$YELLOW Installing zsh plugins (autopair, syntax highlight)"
git clone https://github.com/hlissner/zsh-autopair
git clone https://github.com/zsh-users/zsh-syntax-highlighting
echo "$GREEN Installed zsh plugins$RESET\n"

# Install fzf
echo "$YELLOW Installing fzf$RESET"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
rm -rf ~/.fzf
echo "$GREEN Installed fzf$RESET\n"

# Install neovim
echo "$YELLOW Installing neovim$RESET"
ifpacman neovim
ifpacman python-neovim
ifaptget neovim
ifaptget python3-neovim
echo "$GREEN Installed neovim$RESET\n"

# Install vim-plug
echo "$YELLOW Installing vim-plug$RESET"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "$GREEN Installed vim-plug$RESET\n"

# Clone nzenvim
echo "$YELLOW Installing nzenvim$RESET"
cd ~/.config
git clone https://github.com/deniskabana/nzenvim nvim
cd ~
echo "$GREEN Installed nzenvim$RESET\n"

# Install diff-so-fancy
echo "$YELLOW Installing diff-so-fancy$RESET"
sudo yarn global add diff-so-fancy >/dev/null
echo "$GREEN Installed diff-so-fancy$RESET\n"

# Install oh-my-zsh
echo "$YELLOW Installing oh-my-zsh$RESET"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "$GREEN Installed oh-my-zsh$RESET\n"

# Install fd
echo "$YELLOW Installing fd$RESET"
if command -v dpkg 2>/dev/null >/dev/null; then
  cd ~
  curl -LO https://github.com/sharkdp/fd/releases/download/v7.1.0/fd-musl_7.1.0_amd64.deb
  sudo dpkg -i fd-musl_7.1.0_amd64.deb
fi
ifpacman fd
echo "$GREEN Installed fd$RESET\n"

# Install rigrep
echo "$YELLOW Installing ripgrep$RESET"
if command -v dpkg 2>/dev/null >/dev/null; then
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.9.0/ripgrep_0.9.0_amd64.deb
  sudo dpkg -i ripgrep_0.9.0_amd64.deb
fi
ifpacman ripgrep
echo "$GREEN Installed ripgrep$RESET\n"

# Install pygmentize
echo "$YELLOW Installing pygments$RESET"
if command -v pip 2>/dev/null >/dev/null; then
  stat_installing "pygmentize"
  sudo pip install Pygments
  stat_success "pygmentize"
fi
echo "$GREEN Installed pygments$RESET\n"

# Install java jre
echo "$YELLOW Installing java$RESET"
if command -v apt-get 2>/dev/null >/dev/null; then
  ifaptget default-jre default-jdk
fi
if command -v pacman 2>/dev/null >/dev/null; then
  ifpacman jre10-openjdk-headless jre10-openjdk jdk10-openjdk openjdk10-doc openjdk10-src
fi
echo "$GREEN Installed java$RESET\n"

# Wrap up
clear
echo "$MAGENTA We are now all set, baby!$RESET"
zsh
