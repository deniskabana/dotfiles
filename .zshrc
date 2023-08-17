# SET-UP
# --------------------

# Zshell setup
ZSH_THEME="" # No theme because I use pure-prompt
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH" # Unix paths setup
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh # Import oh-my-zsh
plugins=(colored-man-pages) # ZSH plugins setup
set blink-matching-paren on # Highlight matching parentheses pairs
bindkey -v # Vim-like cursor control

# Android studio + React Native
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Set up folder alias for ~/projects to ~p
setopt AUTO_NAME_DIRS
p=$HOME/projects

# VARIABLES USED IN ZSHRC
# --------------------

export GIT_DIFF_FILE='git diff --no-prefix --color-words --ignore-space-change'
export GIT_BRANCH_NAME='git rev-parse --abbrev-ref HEAD'

# ALIASES
# --------------------

# CD aliases and vim
alias cdp='cd ~/projects'
alias cdn='cd ~/projects/NKSTRS'
alias cdk='cd ~/projects/KPMG'
alias vim='nvim'
alias gsvim='vim $(gld | fzf --preview "$GIT_DIFF_FILE -- {}")' # Open a git modified file in vim

# Git
alias g='git'
alias groot='cd $(git rev-parse --show-toplevel)' # Groot, lol; Goes to git root dir

# Git fetch
alias gf='g fetch'
alias gfa='gf --all' # Fetch all

# Git commit
alias gc='g commit'
alias gca='gc --amend'
alias gcax='gca --no-edit' # Amend without editing message

# Git commit (ignore git hooks)
alias gc!='gc --no-verify'
alias gca!='gca --no-verify'
alias gcax!='gcax --no-verify'

# Git Status
alias gstatus='g status' # Full status
alias gs='echo "\n \e[0m\e[4m\e[34m$(eval $GIT_BRANCH_NAME)\e[0m" && gstatus -s' # Git superpowered shorthand

# Backup to a new *_BACKUP git branch
alias backup='gbr $(eval $GIT_BRANCH_NAME)_BACKUP && echo -e "\e[0m\e[34mCreated a new backup branch!\e[0m"' # Create git backup

# Git stash
alias gsh='g stash'
alias gsha='gsh apply' # Apply stash
alias gshl='gsh list' # List stash

# Git checkout
alias gch='g checkout'
alias gchb='gch $(gbl --format="%(refname:short)" | fzf --preview "git log --pretty=\"%Cblue%h %Cred%ar %Cgreen(%an) %Creset%s\" --first-parent {}")' # Git fuzzy checkout branch (all)
alias gchbl='gch $(gbr --list --format="%(refname:short)" | fzf --preview "git log --pretty=\"%Cblue%h %Cred%ar %Cgreen(%an) %Creset%s\" --first-parent {}")' # Git fuzzy checkout branch (LOCAL)

# Git branch
alias gbr='g branch'
alias gb='gch -b' # Git checkout to new branch
alias gbl='gbr --all' # Git branch list (all)

# Git log
alias gl='g log --pretty="%Cblue%h %Cred%ar %Cgreen(%an) %Creset%s"'
alias glg='gl --graph' # Git visual branch graph

# Git ls-files
alias gls='g ls-files'
alias glm='gls -m --exclude-standard --deduplicate' # List unstaged and modified files - use with other aliases / functions

# Git diff
alias gd='g diff'
alias gld='gd --name-only --diff-filter=M --relative .' # Git list diff - useful in ~/.zshrc
alias gdf='gld | fzf --preview "$GIT_DIFF_FILE -- {}" >/dev/null' # Diff files from a list of modified files - with fuzzy search

# Git add
alias ga='g add'
alias gad='ga -A' # Add everything

# Git reset & clean
alias gclr='g reset . && gch . && g clean -fd' # DESTROY ALL CHANGES

# Git rebase
alias greb='g rebase'
alias gri='greb --interactive' # Interactive rebase
alias grc='greb --continue' # Rebase continue
alias gra='greb --abort' # Rebase abort
alias grs='greb --skip' # Rebase skip current
alias grib='gbl --format="%(refname:short)" | fzf --preview "git log --pretty=\"%Cblue%h %Cred%ar %Cgreen(%an) %Creset%s\" --first-parent {}" | xargs echo' # Interactive rebase to a commit from fuzzy selection (with preview)

# Browse git entities with fuzzy search
alias ghist='gbl --format="%(refname:short)" | fzf --preview "git log --pretty=\"%Cblue%h %Cred%ar %Cgreen(%an) %Creset%s\" --first-parent {}" >/dev/null'

# Node.js
alias xnode='sudo killall node' # Kill all node instances






# WORK IN PROGRESS (NOT TIDIED UP YET)
# --------------------

alias fuck='echo "Running: \e[32msudo \e[35m\e[4m$(fc -ln -1)\e[0m" && sudo $(fc -ln -1)' # Re-run as sudo
alias y='yarn' # Yarn
alias ys='y start' # Yarn start
alias yd='y dev' # Yarn run "dev" script
alias yr='y run' # Yarn run
alias yys='y && ys' # Yarn install and run
alias yyd='y && yd' # Yarn install and run "dev" script
alias ya='y add' # Yarn add (dependency)
alias yad='y add -D' # Yarn add (dependency)
alias yt='y test' # Run tests
alias push!='push --no-verify'
alias force!='force --no-verify'

alias fzv='vim $(fzf)' # Fuzzy-search and vim open
alias fzps='fzf --preview "head -60 {} | pygmentize"' # Fzf with preview

function tldr() { # TLDR: colored less output
  pygmentize -g $@ | less -r
}
function nrun() { # Run from node_modules in CWD
  eval ./node_modules/.bin/$@
}
function unstage() { # Unstage file (fuzzy with diff preview)
  FILE="$(gd --name-only --cached | fzf --preview 'git diff --staged --color-words --')"

  if [ -z "$FILE" ]
  then
    echo "Reset cancelled."
  else
    eval git reset $FILE && gs
  fi
}
function branchd() { # Delete a branch
  BRANCH="$(git branch | fzf | sed -e 's/\( \|\*\)//g')"
  CUR_BRANCH="$(eval $GIT_BRANCH_NAME)"
  echo "Delete branch \e[33m$BRANCH\e[0m? \e[34m(y/\e[32;1mN\e[0m)"
  if [[ $BRANCH = $CUR_BRANCH ]]
  then
    echo "Switching branch to delete current branch."
    eval git checkout --quiet $(git branch | rg '^[[:space:]]+[A-Za-z0-9]+' | head -n 1)
  fi
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    eval git branch -D $BRANCH
  fi
}
function push() { # Git push (current branch)
  BRANCH="$(eval $GIT_BRANCH_NAME)"
  REMOTE="$(git remote)"
  echo "Pushing to branch \e[33m$BRANCH\e[0m on \e[34m$REMOTE\e[0m..."
  eval git push origin $BRANCH $@
}
function pull() { # Git rebase pull
  BRANCH="$(eval $GIT_BRANCH_NAME)"
  REMOTE="$(git remote)"
  echo "Pulling from branch \e[33m$BRANCH\e[0m on \e[34m$REMOTE\e[0m..."
  eval git fetch --all --prune && git rebase $REMOTE/$BRANCH
}
function rebase() { # Git rebase onto $1 or fzf result
  REMOTE="$(git remote)"
  BRANCH="$1"

  if [ -z "$1" ]
  then
    BRANCH="$(git branch -r | fzf | sed -E 's/^[[:space:]]*[A-Za-z0-9]+\///')"
  fi

  echo "Rebasing to \e[34m$BRANCH\e[0m on $REMOTE..."
  eval git pull --rebase $REMOTE $BRANCH
}
function force() { # Force push with lease
  BRANCH="$(eval $GIT_BRANCH_NAME)"
  REMOTE="$(git remote)"
  echo "Are you sure you want to force-push to \e[33m$BRANCH\e[0m? \e[34m(y/\e[32;1mN\e[0m)"
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    eval git push --force-with-lease $REMOTE $BRANCH $@
  fi
}
function ffinish() { # Add all, commit message $1 and force push
  echo "Git add, commit --amend --no-edit, push"
  gad
  gc --amend --no-edit $1
  force $@
}
function finish() { # Add all, commit message $1 and push
  echo "Git add, commit and push..."
  git add -A
  git commit -m $1 $2 $3 $4
  push $2 $3 $4
}

# Load FZF, set fd as a default file finder (respects .gitignore)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Enable zsh syntax highlighting
source ~/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/zsh-autopair/autopair.zsh

# Launch pure-prompt
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit

# Launch pure-prompt
prompt pure

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/denis/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/denis/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/denis/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/denis/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
