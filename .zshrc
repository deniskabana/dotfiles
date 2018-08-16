export ZSH=$HOME/.oh-my-zsh # This had a reason, I'm sure => learn to document stuff early on, Denis
# DISABLE_AUTO_TITLE="true" # Why did I disable this? ¯\(°_o)/¯
plugins=(vi-mode sudo colored-man-pages)
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/bin:$PATH"
source $ZSH/oh-my-zsh.sh # What is this
ZSH_THEME="" # No theme for pure-prompt
export NODE_ENV='development' # Sure feels nice having the default explicit

function zle-line-init zle-keymap-select {
  # Change the cursor style depending on keymap mode.
  if [[ "$SSH_CONNECTION" == '' ]] {
    case $KEYMAP {
      vicmd)
        printf '\e[0 q' # Box.
        ;;

      viins|main)
        printf '\e[6 q' # Vertical bar.
        ;;
    }
  }
}
zle -N zle-line-init
zle -N zle-keymap-select

set blink-matching-paren on # Google this later

# Aliases and function who will be documented with ~/zsh_docs.sh
alias gf='git fetch' # Git fetch
alias gc='git commit' # Git commit
alias gca='git commit --amend' # Git commit (ammend)
alias gs='git status' # Git status
alias gss='echo "" && git status -s' # Git status - changes
alias g="gss"
alias glm='git ls-files -m' # List unstaged, modified
alias gsh='git stash' # Git stash
alias gch='git checkout' # Git checkout
alias gchf='gch $(gss | sed "s/^\s*\(\w\|??\)\s//" | fzf --preview "git diff --color {} | diff-so-fancy") && gss' # Git checkout file (fuzzy)
alias gchb='gch $(git branch --all | fzf)' # Fuzzy git checkout
alias gb='git checkout -b' # Git checkout -> new branch
alias gbr='git branch' # Git branch
alias gbl='git branch --all' # Git branch list (all)
alias gl='git log --pretty="%Cblue%h %Cred%ar %Cgreen(%an) %Creset%s"'
alias glg='gl --graph' # Git visual branch graph
alias gshow='git show $(gl | fzf | cut -d \  -f1) | less -r' # Interactive git show
alias gd='git diff' # Git diff
alias ga='git add' # Git add
alias gad='git add -A' # Git add everything (-A)
alias gaf='ga $(glm | fzf --preview "git diff --color {} | diff-so-fancy") && gss' # Git add file (fuzzy)
alias gsvim='vim $(git status -s | fzf -m)' # Vim unstaged files
alias ghist='git show $(gl --follow $(fzf) | fzf | cut -d \  -f1 )' # File history in git
alias gclr='git reset . && gch . && git clean -fd' # DESTROY changes
alias gmt='git mergetool' # Git start merge tool
alias grc='git rebase --continue' # Rebase continue
alias gra='git rebase --abort' # Rebase abort
alias grs='git rebase --skip' # Rebase skip current

alias fuck='echo "Running: \e[32msudo \e[35m\e[4m$(fc -ln -1)\e[0m" && sudo $(fc -ln -1)' # Re-run as sudo
alias ys='yarn start -s' # Yarn start
alias y='yarn' # Yarn
alias yr='yarn run' # Yarn run

alias concepts='pushd ~/projects/concepts-catalogue > /dev/null' # cd to concepts
alias fzv='vim $(fzf)' # Fuzzy-search and vim open
alias fzps='fzf --preview "head -60 {} | pygmentize"' # Fzf with preview
alias mci='mvn clean install' # Maven clean install
alias mi='mvn install' # Maven install
alias mc='mvn clean' # Maven clean
alias qmvn='concepts && pushd components-generic && mi && popd && pushd catalogue-generator && mi && popd && popd' # Quick mvn build

function tldr() { # TLDR: colored less output
  pygmentize -g $@ | less -r
}
function nrun() { # Node module run
  eval ./node_modules/.bin/$@
}
function unstage() { # Unstage file
  FILE="$(gd --name-only --cached | fzf --preview 'git diff --staged --color {} | diff-so-fancy')"

  if [ -z "$FILE" ]
  then
    echo "Reset cancelled."
  else
    eval git reset $FILE && gss
  fi
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
function push() { # Git push (current)
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  REMOTE="$(git remote)"
  echo "Pushing to branch \e[33m$BRANCH\e[0m on \e[34m$REMOTE\e[0m..."
  eval git push origin $BRANCH
}
function pull() { # Git pull -r (current)
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  REMOTE="$(git remote)"
  echo "Pulling from branch \e[33m$BRANCH\e[0m on \e[34m$REMOTE\e[0m..."
  eval git pull --rebase $REMOTE $BRANCH
}
function rebase() { # Git rebase onto ?$1
  REMOTE="$(git remote)"
  BRANCH="$1"

  if [ -z "$1" ]
  then
    BRANCH="$(git branch -r | fzf | sed 's/\( \|\*\)//g' | sed 's/^[A-Za-z]*\///')"
  fi

  echo "Rebasing to \e[34m$BRANCH\e[0m on $REMOTE..."
  eval git pull --rebase $REMOTE $BRANCH
}
function force() { # Force push (lease)
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  REMOTE="$(git remote)"
  echo "Are you sure you want to force-push to \e[33m$BRANCH\e[0m? \e[34m(y/\e[32;1mN\e[0m)"
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    eval git push --force-with-lease $REMOTE $BRANCH
  fi
}
function finish() { # Add all, commit and push
  echo "Git add, commit and push..."
  git add -A
  git commit -m $1
  push
}

# Other non-documented aliases
alias scat='pygmentize -g'
alias pacman='yes | sudo pacman'
alias vim='nvim'
alias serve='concepts && cd catalogue-generator/target/catalogue-generator && http-server >/dev/null'
alias CHR='concepts && node utils/dev/css-hot-reload --port 8081'
alias x='clear'

# Load FZF, set fd as a default file finder (respects .gitignore)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Enable zsh syntax highlighting
source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable auto-closing of paired symbols
source ~/zsh-autopair/autopair.zsh

# Launch pure-prompt
fpath+=('/usr/local/lib/node_modules/pure-prompt/functions')
autoload -U promptinit; promptinit

# Directory overhead
setopt AUTO_NAME_DIRS
C=$HOME/projects/concepts-catalogue

prompt pure
# Show current time with pure-prompt
PROMPT='%F{yellow}%* '$PROMPT
