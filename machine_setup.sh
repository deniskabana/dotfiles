#1/bin/bash

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
echo "$YELLOW$BOLD Installing needed applications... $RESET"

# Visual feedback - status
log() {
  echo "$1$RESET"
}
stat_installing() {
  log "$MAGENTA Currently installing:$RESET $UNDERLINE$1..."
}
stat_success() {
  log "$GREEN Successfuly installed $1!"
}

# Update the system
log "$CYAN Updating the core system..."
if command -v apt-get 2>/dev/null >/dev/null; then
  log "$CYAN Running apt-get update"
  sudo apt-get update >/dev/null
  log "$CYAN Running apt-get upgrade"
  sudo apt-get upgrade >/dev/null
fi
if command -v pacman 2>/dev/null >/dev/null; then
  log "$CYAN Running pacman -Syy..."
  sudo pacman -Syy >/dev/null
fi
log "$GREEN System successfully updated!"

# Installing tools
ipacman() {
  if command -v pacman 2>/dev/null >/dev/null; then
    yes | sudo pacman -S $@ > /dev/null
  fi
}
iapt() {
  if command -v apt 2>/dev/null >/dev/null; then
    sudo apt -y install $@ > /dev/null
  fi
}
iaptget() {
  if command -v apt-get 2>/dev/null >/dev/null; then
    sudo apt-get -y install $@ > /dev/null
  fi
}

# Install basic tools
log "$YELLOW Installing curl and wget"
iaptget curl
iaptget wget
ipacman curl
ipacman wget
stat_success "curl and wget"

# Install yaourt if available
if command -v pacman 2>/dev/null >/dev/null; then
  log("$CYAN Try installing yaourt...")
  sudo touch /etc/pacman.conf
  sudo echo \[archlinuxfr\] >> /etc/pacman.conf
  sudo echo SigLevel = Never >> /etc/pacman.conf
  sudo echo Server = http://repo.archlinux.fr/\$arch >> /etc/pacman.conf
  sudo pacman -Sy yaourt > /dev/null
  stat_success "yaourt"
fi

# Install git
if command -v git 2>/dev/null >/dev/null; then
  stat_installing "git"
  ipacman git-all
  iapt git-all
  stat_success "git"
else
  log "$GREEN Git is already installed on this system."
fi

# Clone my repository in home folder (includes zshrc and vim settings)
log "$CYAN Download dotfiles into ~"
cd ~
git init
git remote add origin https://github.com/deniskabana/dotfiles
git fetch origin
git checkout -b master --track origin/master
log "$GREEN That went well!"

# Install neovim
if command -v neovim 2>/dev/null >/dev/null; then
  stat_installing "neovim"
  ipacman neovim
  ipacman python-neovim
  iaptget neovim
  iaptget python3-neovim
  stat_success "neovim"
else
  log "$GREEN neovim is already installed on this system."
fi

# Install vim-plug
stat_installing "vim-plug"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
stat_success "vim-plug"

# Clone nzenvim
stat_installing "nzenvim"
cd ~/.config
git clone https://github.com/deniskabana/nzenvim nvim
cd ~
stat_success "nzenvim"

# Install nodejs
stat_installing "nodejs"
if command -v apt-get 2>/dev/null >/dev/null; then
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  iaptget nodejs
fi
ipacman nodejs npm
stat_success "nodejs"

# Install yarn
stat_installing "yarn"
if command -v apt-get 2>/dev/null >/dev/null; then
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && iaptget yarn
fi
ipacman yarn
stat_success "yarn"

# Install diff-so-fancy
stat_installing "diff-so-fancy"
sudo yarn global add diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global color.ui true
git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"
git config --global color.diff.meta       "yellow"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"
stat_success "diff-so-fancy"

# Install zsh
stat_installing "zsh (latest)"
iaptget zsh
ipacman zsh
stat_success "zsh (latest)"

# Install oh-my-zsh
stat_installing "oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
stat_success "oh-my-zsh"

# Install zsh-syntax-highlight
stat_installing "zsh-syntax-highlighting"
cd ~
git clone https://github.com/zsh-users/zsh-syntax-highlighting
stat_success "zsh-syntax-highlighting"

# Install fd
stat_installing "fd"
iaptget fd
ipacman fd
stat_success "fd"

# Install ripgrep
stat_installing "ripgrep"
if command -v dpkg 2>/dev/null >/dev/null; then
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.9.0/ripgrep_0.9.0_amd64.deb
  sudo dpkg -i ripgrep_0.9.0_amd64.deb
fi
ipacman ripgrep
stat_success "ripgrep"

# Install pure-prompt
stat_installing "pure-prompt"
sudo yarn global add pure-prompt
stat_success "pure-prompt"

# Install fzf
stat_installing "fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
rm -rf ~/.fzf
stat_success "fzf"

# Install pip
stat_installing "pip"
cd ~
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
rm get-pip.py
stat_success "pip"

# Install pygmentize
if command -v pip 2>/dev/null >/dev/null; then
  stat_installing "pygmentize"
  sudo pip install Pygments
  stat_success "pygmentize"
fi

# Install java jre
stat_installing "java"
if command -v apt-get 2>/dev/null >/dev/null; then
  iaptget default-jre default-jdk
fi
if command -v pacman 2>/dev/null >/dev/null; then
  ipacman jre10-openjdk-headless jre10-openjdk jdk10-openjdk openjdk10-doc openjdk10-src
fi
stat_success "java"

# Wrap up
log("\n$GREEN We are now all set, baby!")
zsh
exit
