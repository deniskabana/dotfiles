export ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""
DISABLE_AUTO_TITLE="true"
plugins=(vi-mode sudo colored-man-pages)
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$(ruby -e 'print Gem.user_dir')/bin:$PATH"
source $ZSH/oh-my-zsh.sh
source $ZSH/oh-my-zsh.sh
export NODE_ENV='development'

set editing-mode vi
set blink-matching-paren on

# DOCS_PARSE_START
alias gf='git fetch' # Git fetch
alias gc='git commit' # Git commit
alias gca='git commit --amend' # Git commit (ammend)
alias gs='git status' # Git status
alias gss='echo "" && git status -s' # Git status (changes only, compact)
alias gsh='git stash' # Git stash
alias gch='git checkout' # Git checkout
alias gchb='gch $(git branch --all | fzf)' # Change branch with fuzzy search
alias gb='git checkout -b' # New branch + checkout
alias gbl='git branch --all' # Git branch list
alias gl='git log --pretty="%Cblue%h %Cred%ar %Cgreen(%an) %Creset%s"' # One line colorful pretty-print log
alias glg='gl --graph' # Git visual branch graph
alias gshow='git show $(gl | fzf | cut -d \  -f1)' # Search & display commit details
alias gd='git diff' # Git diff
alias ga='git add' # Git add
alias gad='git add -A' # Git add all
alias gsvim='vim $(git status -s | fzf -m)' # Open unstaged file from git status in vim
alias ghist='git show $(gl --follow $(fzf)| fzf | cut -d \  -f1 )' # File history in git
alias gclr='gch . && git clean -fd' # DESTROY changes and staged/unstaged files

alias gmt='git mergetool' # Git start merge tool
alias grc='git rebase --continue' # Rebase continue
alias gra='git rebase --abort' # Rebase abort
alias grs='git rebase --skip' # Rebase skip current

alias vim='nvim' # Neovim alias

alias ys='yarn start -s' # Yarn start
alias y='yarn' # Yarn
alias yr='yarn run' # Yarn run

alias cat="pygmentize -g" # Colorized cat
alias pacman='sudo pacman' # Sudo alias

alias concepts='pushd ~/projects/concepts-catalogue' # cd to concepts
alias fzv='vim $(fzf)' # Fuzzy-search and vim open
alias fzp='fzf --preview "head -100 {}"' # Fuzzy search with file preview
alias mci='mvn clean install' # Mvn clean install
alias mi='mvn install' # Mvn install
alias qmvn='concepts && pushd components-generic && mi && popd && pushd catalogue-generator && mi && popd && popd' # Quick mvn build

function tldr() { # TLDR: colored less output
  pygmentize -g $@ | less -r
}
function nrun() { # Node module run
  eval ./node_modules/.bin/$@
}
function branchd() { # Delete branch
  BRANCH="$(git branch | fzf | sed 's/\( \|\*\)//g')"
  CUR_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  echo "Delete branch \e[33m$BRANCH\e[0m? \e[34m(y/\e[32;1mN\e[0m)"
  if [[ $BRANCH = $CUR_BRANCH ]]
  then
    echo "Switching branch to delete current branch."
    eval git checkout --quiet $(git branch | rg '^\s+\w' | head -n 1)
  fi
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    eval git branch -d $BRANCH
  fi
}
function push() { # Push current branch
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  REMOTE="$(git remote | fzf)"
  echo "Pushing to branch \e[33m$BRANCH\e[0m on \e[34m$REMOTE\e[0m..."
  eval git push origin $BRANCH
}
function pull() { # Pull rebase current branch
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  REMOTE="$(git remote)"
  echo "Pulling from branch \e[33m$BRANCH\e[0m on \e[34m$REMOTE\e[0m..."
  eval git pull --rebase $REMOTE $BRANCH
}
function rebase() { # Rebase to branch
  REMOTE="$(git remote | fzf)"
  echo "Rebasing to \e[34m$1\e[0m on $REMOTE..."
  eval git pull --rebase $REMOTE $1
}
function force() { # Force push (\w lease) current branch
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  REMOTE="$(git remote)"
  echo "Are you sure you want to force-push to \e[33m$BRANCH\e[0m? \e[34m(y/\e[32;1mN\e[0m)"
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    eval git push --force-with-lease $REMOTE $BRANCH
  fi
}
function finish() { # Git add, commit -m $1, push
  echo "Git add, commit and push..."
  git add -A
  git commit -m $1
  push
}
# DOCS_PARSE_END

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

source /home/denis/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fpath+=('/usr/local/lib/node_modules/pure-prompt/functions')
autoload -U promptinit; promptinit
prompt pure
