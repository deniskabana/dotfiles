ZSH_THEME="" # No theme for pure-prompt
export ZSH=$HOME/.oh-my-zsh # This had a reason, I'm sure => learn to document stuff early on, Denis
# DISABLE_AUTO_TITLE="true" # Why did I disable this? ¯\(°_o)/¯
plugins=(colored-man-pages zsh-autosuggestions)
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/bin:$PATH"
source $ZSH/oh-my-zsh.sh # What is this
export NODE_ENV='development' # Sure feels nice having the default explicit

# Vi mode
bindkey -v

set blink-matching-paren on # Google this later

# Aliases and functions - docs at ~/zsh_docs.sh or alias "docs"
alias gf='git fetch' # Git fetch
alias gc='git commit' # Git commit
alias gca='git commit --amend' # Git commit amend
alias gs='git status' # Git status
alias gss='echo "" && git status -s' # Git status - short
alias g='git status >/dev/null && echo "\n \e[0m\e[4m\e[34m$(git rev-parse --abbrev-ref HEAD)\e[0m" && git status -s' # Git superpowered shorthand
alias glm='git ls-files -m' # List unstaged and modified
alias gsh='git stash' # Git stash
alias gch='git checkout' # Git checkout
alias gchf='gch $(gss | sed "s/^\s*\(\w\|??\)\s//" | fzf --preview "git diff --color {} | diff-so-fancy") && gss' # Git checkout file (fuzzy pick)
alias gchb='gch $(git branch --all | fzf)' # Fuzzy git checkout to a branch
alias gb='git checkout -b' # Git checkout to new branch
alias gbr='git branch' # Git branch
alias gbl='git branch --all' # Git branch list (all)
alias gl='git log --pretty="%Cblue%h %Cred%ar %Cgreen(%an) %Creset%s"' # Git log
alias glg='gl --graph' # Git visual branch graph
alias gshow='git show $(gl | fzf | cut -d \  -f1) | less -r' # Git show (interactive)
alias gd='git diff' # Git diff
alias ga='git add' # Git add $@
alias gad='git add -A' # Git add everything (-A)
alias gaf='ga $(glm | fzf --preview "git diff --color {} | diff-so-fancy") && gss' # Git fuzzy add unstaged file
alias gsvim='vim $(git status -s | fzf -m)' # Fuzzy open from unstaged files in vim
alias ghist='git show $(gl --follow $(fzf) | fzf | cut -d \  -f1 )' # File history in git (fuzzy pick)
alias gclr='git reset . && gch . && git clean -fd' # DESTROY ALL CHANGES
alias gmt='git mergetool' # Git start merge tool
alias grc='git rebase --continue' # Rebase continue
alias gra='git rebase --abort' # Rebase abort
alias grs='git rebase --skip' # Rebase skip current
alias xnode='sudo killall node' # Kill all node instances

alias fuck='echo "Running: \e[32msudo \e[35m\e[4m$(fc -ln -1)\e[0m" && sudo $(fc -ln -1)' # Re-run as sudo
alias ys='yarn start -s' # Yarn start
alias y='yarn' # Yarn
alias yr='yarn run' # Yarn run

alias concepts='cd ~/projects/concepts-catalogue > /dev/null' # cd to concepts (can use $ ~C)
alias fzv='vim $(fzf)' # Fuzzy-search and vim open
alias fzps='fzf --preview "head -60 {} | pygmentize"' # Fzf with preview
alias mci='mvn clean install' # Maven clean install
alias mi='mvn install' # Maven install
alias mc='mvn clean' # Maven clean
alias qmvn='concepts && pushd components-generic && mi && popd && pushd catalogue-generator && mi && popd 2>/dev/null && concepts' # Quick mvn build

function tldr() { # TLDR: colored less output
  pygmentize -g $@ | less -r
}
function nrun() { # Run from node_modules in CWD
  eval ./node_modules/.bin/$@
}
function unstage() { # Unstage file (fuzzy with diff preview)
  FILE="$(gd --name-only --cached | fzf --preview 'git diff --staged --color {} | diff-so-fancy')"

  if [ -z "$FILE" ]
  then
    echo "Reset cancelled."
  else
    eval git reset $FILE && gss
  fi
}
function branchd() { # Delete a branch
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
function push() { # Git push (current branch)
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  REMOTE="$(git remote)"
  echo "Pushing to branch \e[33m$BRANCH\e[0m on \e[34m$REMOTE\e[0m..."
  eval git push origin $BRANCH
}
function pull() { # Git rebase pull
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  REMOTE="$(git remote)"
  echo "Pulling from branch \e[33m$BRANCH\e[0m on \e[34m$REMOTE\e[0m..."
  eval git pull --rebase $REMOTE $BRANCH
}
function rebase() { # Git rebase onto $1 or fzf result
  REMOTE="$(git remote)"
  BRANCH="$1"

  if [ -z "$1" ]
  then
    BRANCH="$(git branch -r | fzf | sed 's/\( \|\*\)//g' | sed 's/^[A-Za-z]*\///')"
  fi

  echo "Rebasing to \e[34m$BRANCH\e[0m on $REMOTE..."
  eval git pull --rebase $REMOTE $BRANCH
}
function force() { # Force push with lease
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  REMOTE="$(git remote)"
  echo "Are you sure you want to force-push to \e[33m$BRANCH\e[0m? \e[34m(y/\e[32;1mN\e[0m)"
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    eval git push --force-with-lease $REMOTE $BRANCH
  fi
}
function finish() { # Add all, commit message $1 and push
  echo "Git add, commit and push..."
  git add -A
  git commit -m $1
  push
}
function finishc() { # Finish concepts task/branch - automated
  CUR_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  DEFAULT_TASK_ID="$(echo $CUR_BRANCH | sed -E "s/^feature\/(\w+)-([0-9]{1,5})-.*/\1-\2/")"
  DEFAULT_MSG="$(echo $CUR_BRANCH | sed -E "s/^feature\/\w+-[0-9]{1,5}-(.*)/\1/" | sed -E "s/-/ /g")"

  TASK_ID=""
  MSG=""

  # Get task ID
  echo "\e[34mEnter task ID or leave empty to use default\e[0m \e[2m\e[4m($DEFAULT_TASK_ID)\e[0m"
  read USER_TASK_ID
  if [ -z "$USER_TASK_ID" ]
  then
    TASK_ID=$DEFAULT_TASK_ID
  else
    TASK_ID=$USER_TASK_ID
  fi

  # Get commit message
  echo "\e[34mEnter commit message or leave empty to use default\e[0m \e[2m\e[4m($DEFAULT_MSG)\e[0m"
  read USER_MSG
  if [ -z "$USER_MSG" ]
  then
    MSG=$DEFAULT_MSG
  else
    MSG=$USER_MSG
  fi

  echo "\e[32mFinal commit message: \e[0m\e[35m$TASK_ID $MSG\e[0m"

  # Rebase to develop?
  echo "\e[33mDo you want to rebase to \e[34mdevelop\e[33m?\e[0m (\e[31my\e[0m/\e[1mN\e[0m)"
  read REBASE
  if [[ $REBASE =~ ^[Yy]$ ]]
  then
    rebase develop
  fi

  # Success
  finish "$TASK_ID $MSG"
}
alias docs='~/zsh_docs.sh' # Display my functions docs

# Other non-documented aliases
alias scat='pygmentize -g'
alias pacman='yes | sudo pacman'
alias vim='nvim'
alias serve='concepts && cd catalogue-generator/target/catalogue-generator && http-server >/dev/null'
alias CHR='concepts && node utils/dev/css-hot-reload --port 8081'
alias x='clear'
alias osrs='java -jar ~/Documents/RuneLite.jar --mode=OFF'

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

# Launch pure-prompt
prompt pure

# ZLE hooks for prompt's vi mode status
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

# Show current time with pure-prompt
PROMPT='%F{yellow}%* '$PROMPT

# If using autosuggestions, apply this
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
