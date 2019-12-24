#!/usr/bin/env bash

echo "If anything goes wrong, finish it manually"
read

# NOTES:
#
# 1) https://www.reddit.com/r/Dell/comments/9puckt/ubuntu_1810_on_dell_xps_15_9570/
# 2) https://github.com/JackHack96/dell-xps-9570-ubuntu-respin
# 3) https://github.com/hiroppy/fusuma
# 4) https://wiki.archlinux.org/index.php/Undervolting_CPU

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  >&2 echo -e "Please run the setup script as root!"
  exit 2
fi

# Install basics
apt install curl
apt install wget
apt install git
apt install zsh

# Run xps-tweaks.sh from Note 2
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/dell-xps-9570-ubuntu-respin/master/xps-tweaks.sh)"

# Fusuma setup
echo "Installing fusuma"
read
apt install libinput-tools
apt install ruby
gem install fusuma
apt install xdotool

# Oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Node.js, npm and yarn
apt install nodejs
apt install npm
npm install --global yarn

# php
apt install php

# Install pure-prompt for zsh
yarn global add pure-prompt

# Install zsh plugins
git clone https://github.com/hlissner/zsh-autopair
git clone https://github.com/zdharma/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions

# Install terminal additions
# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
# ripgrep
apt install ripgrep
# fd
apt install fd-find

# Install python and pip
apt install python
apt install python3
apt install python-pip
apt install python3-pip

# Install neovim
apt install neovim
apt install python-neovim
apt install python3-neovim

# Diff so fancy
yarn global add diff-so-fancy

# http-server
yarn global add http-server

# Pygmentize (coloured commands tldr and scat)
pip install Pygments

# Use my .zshrc
mv ~/.zshrc ~/.default_zshrc
cd ~
curl https://raw.githubusercontent.com/deniskabana/dotfiles/master/.zshrc --output .zshrc
