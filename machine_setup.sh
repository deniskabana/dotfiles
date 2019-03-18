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
echo -e "$YELLOW$BOLD Setting up machine...$RESET\n"

# Update the system
echo -e "$YELLOW Updating the core system...$RESET"
if command -v apt-get 2>/dev/null >/dev/null; then
  echo -e "$CYAN Running apt-get update"
  sudo apt-get update >/dev/null
  echo -e "$CYAN Running apt-get upgrade"
  sudo apt-get -y upgrade >/dev/null
fi
if command -v pacman 2>/dev/null >/dev/null; then
  echo -e "$CYAN Running pacman -Syy..."
  yes | sudo pacman -Syy >/dev/null
fi
echo -e "$RESET$GREEN System successfully updated!$RESET"

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
echo -e "$YELLOW Installing curl and wget$RESET"
ifaptget curl
ifaptget wget
ifpacman curl
ifpacman wget
echo -e "$GREEN Installed curl and wget$RESET\n"

# Install yay if available
if command -v pacman 2>/dev/null >/dev/null; then
  echo -e "$CYAN Try installing yay... $RESET"
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  cd ~
  echo -e "$GREEN Installed yay$RESET\n"
fi

# Install git
echo -e "$YELLOW Installing git$RESET"
ifpacman git
ifaptget git
echo -e "$GREEN Installed git$RESET\n"

# Install zsh
echo -e "$YELLOW Installing zsh$RESET"
ifpacman zsh
ifaptget zsh
echo -e "$GREEN Installed zsh$RESET\n"

# Clone my repository in home folder (includes zshrc and vim settings)
echo -e "$CYAN Download dotfiles into ~$RESET"
cd ~
git init
git remote add origin https://github.com/deniskabana/dotfiles
git fetch
git checkout -b backup
git checkout -t origin/master -f
git branch -D backup
echo -e "$GREEN That went well!$RESET\n"

# Install nodejs
echo -e "$YELLOW Installing nodejs$RESET"
if command -v apt-get 2>/dev/null >/dev/null; then
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  ifaptget nodejs
fi
ifpacman nodejs npm
echo -e "$GREEN Installed nodejs$RESET\n"

# Install yarn
echo -e "$YELLOW Installing yarn$RESET"
if command -v apt-get 2>/dev/null >/dev/null; then
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo -e "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && ifaptget yarn
fi
ifpacman yarn
echo -e "$GREEN Installed yarn$RESET\n"

# Install pure-prompt
echo -e "$YELLOW Installing pure-prompt$RESET"
sudo yarn global add pure-prompt >/dev/null
echo -e "$GREEN Installed pure-prompt$RESET\n"

# Download zsh plugins I use
echo -e "$YELLOW Installing zsh plugins (autopair, syntax highlight)"
git clone https://github.com/hlissner/zsh-autopair
git clone https://github.com/zsh-users/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo -e "$GREEN Installed zsh plugins$RESET\n"

# Install fzf
echo -e "$YELLOW Installing fzf$RESET"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cd ~/.fzf
sh -c "$(curl -fsSL https://raw.githubusercontent.com/deniskabana/dotfiles/master/install-fzf.sh)"
rm -rf ~/.fzf
echo -e "$GREEN Installed fzf$RESET\n"

# Install neovim
echo -e "$YELLOW Installing neovim$RESET"
ifpacman neovim
ifpacman python-neovim
ifaptget neovim
ifaptget python3-neovim
echo -e "$GREEN Installed neovim$RESET\n"

# Install vim-plug
echo -e "$YELLOW Installing vim-plug$RESET"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo -e "$GREEN Installed vim-plug$RESET\n"

# Clone nzenvim
echo -e "$YELLOW Installing nzenvim$RESET"
cd ~/.config
git clone https://github.com/deniskabana/nzenvim nvim
cd ~
echo -e "$GREEN Installed nzenvim$RESET\n"

# Install diff-so-fancy
echo -e "$YELLOW Installing diff-so-fancy$RESET"
sudo yarn global add diff-so-fancy >/dev/null
echo -e "$GREEN Installed diff-so-fancy$RESET\n"

# Install fd
echo -e "$YELLOW Installing fd$RESET"
if command -v dpkg 2>/dev/null >/dev/null; then
  cd ~
  curl -LO https://github.com/sharkdp/fd/releases/download/v7.1.0/fd-musl_7.1.0_amd64.deb
  sudo dpkg -i fd-musl_7.1.0_amd64.deb
fi
ifpacman fd
echo -e "$GREEN Installed fd$RESET\n"

# Install rigrep
echo -e "$YELLOW Installing ripgrep$RESET"
if command -v dpkg 2>/dev/null >/dev/null; then
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.9.0/ripgrep_0.9.0_amd64.deb
  sudo dpkg -i ripgrep_0.9.0_amd64.deb
fi
ifpacman ripgrep
echo -e "$GREEN Installed ripgrep$RESET\n"

# Install pygmentize
echo -e "$YELLOW Installing pygments$RESET"
if command -v pip 2>/dev/null >/dev/null; then
  stat_installing "pygmentize"
  sudo pip install Pygments
  stat_success "pygmentize"
fi
echo -e "$GREEN Installed pygments$RESET\n"

# Install java jre
echo -e "$YELLOW Installing java$RESET"
if command -v apt-get 2>/dev/null >/dev/null; then
  ifaptget default-jre default-jdk
fi
if command -v pacman 2>/dev/null >/dev/null; then
  ifpacman jre10-openjdk-headless jre10-openjdk jdk10-openjdk openjdk10-doc openjdk10-src
fi
echo -e "$GREEN Installed java$RESET\n"

# Install oh-my-zsh
echo -e "$YELLOW Installing oh-my-zsh$RESET"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/deniskabana/dotfiles/master/install-oh-my-zsh.sh)"
echo -e "$GREEN Installed oh-my-zsh$RESET\n"

# Wrap up
clear
echo -e "$MAGENTA We are now all set, baby!$RESET"
rm .zshrc
mv .zshrc.pre-oh-my-zsh .zshrc
env zsh -l
