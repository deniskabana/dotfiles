# --------------------
# SET-UP ZSH
# --------------------

ZSH_THEME="spaceship" 
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH" # Unix paths
export ZSH=$HOME/.oh-my-zsh
set blink-matching-paren on # Highlight matching parentheses pairs

# --------------------
# PLUGINS + oh-my-zsh
# --------------------

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
plugins=(zsh-vi-mode auto-notify)
source $ZSH/oh-my-zsh.sh # Import oh-my-zsh
plugins+=(colored-man-pages zsh-auto-nvm) # ZSH plugins setup

# Custom plugins
source ~/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
zvm_after_init_commands+=("bindkey \"$terminfo[kcuu1]\" history-substring-search-up") # Up arrow
zvm_after_init_commands+=("bindkey \"$terminfo[kcud1]\" history-substring-search-down") # Down arrow

# FZF history (^R)
source $ZSH_CUSTOM/plugins/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh
ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES=true
ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS=0
ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=0
zvm_after_init_commands+=("bindkey '^R' fzf_history_search")

# Load FZF, set fd as a default file finder (respects .gitignore)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# --------------------
# SHORTCUTS
# --------------------

# Set up folder alias for ~/projects to ~p
setopt AUTO_NAME_DIRS
p=$HOME/projects

# --------------------
# ALIASES
# --------------------

alias cdp='cd ~/projects'
alias vim='nvim'
alias fuck='echo "Running: \e[32msudo \e[35m\e[4m$(fc -ln -1)\e[0m" && sudo $(fc -ln -1)' # Re-run as sudo

# --------------------
# ALIASES / GIT
# --------------------

export GIT_BRANCH_NAME='git rev-parse --abbrev-ref HEAD' # SHortcut for aliases in .zshrc

alias lg='lazygit' # LazyGit alias
alias groot='cd $(git rev-parse --show-toplevel)' # Fun way to get to the git root dir

# Git Status (see turbogit function in this file)
alias g='turbogit' # Super minimal git status
alias gs='g'
alias gss='g status' # Full status

# Git fetch
alias gf='g fetch'
alias gfa='gf --all' # Fetch all

# Git add
alias ga='g add'
alias gad='ga -A' # Add everything

# Git commit
alias gc='g commit'
alias gca='gc --amend'
alias gcax='gca --no-edit' # Amend without editing message
# Add ! suffix to ignore git hooks with commit commands
alias gc!='gc --no-verify'
alias gca!='gca --no-verify'
alias gcax!='gca! --no-edit'

# Push and push force (automatic upstream, current branch, remote "origin")
alias push!='push --no-verify'
alias force!='force --no-verify'

# Git pull, push, rebase lives in functions "pull", "push", "rebase" and "force" (see below)

# Git checkout
alias gch='g checkout'

# Git branch
alias gb='gch -b' # New branch (local + checkout)
alias gba='g branch --all'
alias gbl='g branch --all --list'
# Fast current git branch backup with _BACKUP suffix and switch back
alias gbackup='gb $(eval $GIT_BRANCH_NAME)_BACKUP && echo -e "\e[0m\e[34mCreated a new backup branch!\e[0m" && gch -'

# Git branch -> effictient checkout to branch with fzf
alias gchb='gch $(gbl --format="%(refname:short)" | fzf --ansi --preview "git log --color=always --pretty=\"%Cblue%h %Cred%ar %Cgreen(%an) %Creset%s\" --first-parent {}")' # Git fuzzy checkout branch (all)
alias gchbl='gch $(gb --list --format="%(refname:short)" | fzf --ansi --preview "git log --color=always --pretty=\"%Cblue%h %Cred%ar %Cgreen(%an) %Creset%s\" --first-parent {}")' # Git fuzzy checkout branch (LOCAL)

# Git rebase
alias greb='g rebase'
alias gri='greb --interactive' # Interactive rebase
alias grc='greb --continue' # Rebase continue
alias gra='greb --abort' # Rebase abort

# Git stash
alias gsh='g stash'

# Git log
alias gl='g log --pretty="%Cblue%h %Cred%ar %Cgreen(%an) %Creset%s"' # Pretty one-line log
alias glg='gl --graph' # Git log graph

# Git ls-files
alias gls='g ls-files'
# Git diff
alias gd='g diff'

# DESTROY ALL CHANGES
alias gclr='g reset . && gch . && g clean -fd'

# --------------------
# ALIASES / NODE.JS
# --------------------

# Yarn
alias y='yarn' # Yarn
alias ys='y start' # Yarn start
alias yd='y dev' # Yarn run "dev" script
# Shortcuts for install + run
alias yys='y && ys' # Yarn install and run
alias yyd='y && yd' # Yarn install and run "dev" script
# Install package
alias ya='y add' # Yarn add (dependency)
alias yad='y add -D' # Yarn add (dependency)
# Common test script
alias yt='y test' # Run tests

# Npm
alias np='npmShortcut'
alias npi='np i'
alias npa='np i -S'
alias npd='np i -D'
alias nx='npx nx'
alias ns='npm start'
alias nclr='rm -rf node_modules package-lock.json yarn.lock && np'

# --------------------
# FUNCTIONS
# --------------------

# TLDR: Colored less output
function tldr() { # TLDR: colored less output
  pygmentize -g $@ | less -r
}

# Allows running "n" to install or "n *" for npm *
function npmShortcut() {
  if [ $# -eq 0 ]; then
    eval npm i
  else
    npm "$@"
  fi
}

# --------------------
# FUNCTIONS / GIT
# --------------------

# Shortcut "g" for git status or git *
function turbogit() {
  if [ $# -eq 0 ]; then
    echo "\e[34m \e[0m\e[4m\e[34m$(eval $GIT_BRANCH_NAME)\e[0m" && gss -s
  else
    git "$@"
  fi
}

# Delete branch with fuzzy picker
function branchd() {
  BRANCH="$(git branch | fzf | sed -e 's/\( \|\*\)//g')"
  CUR_BRANCH="$(eval $GIT_BRANCH_NAME)"
  if [[ $BRANCH = $CUR_BRANCH ]]
  then
    echo "Switching branch to delete current branch."
    eval git checkout --quiet $(git branch | rg '^[[:space:]]+[A-Za-z0-9]+' | head -n 1)
  fi
  echo "Delete branch \e[33m$BRANCH\e[0m? \e[34m(y/\e[32;1mN\e[0m)"
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    eval git branch -D $BRANCH
  fi
}

# Git push current branch to current remote
function push() {
  BRANCH="$(eval $GIT_BRANCH_NAME)"
  REMOTE="$(git remote)"
  echo "Pushing to branch \e[33m$BRANCH\e[0m on \e[34m$REMOTE\e[0m..."
  eval git push origin $BRANCH $@
}

# Git pull (fetch all with prune, then rebase)
function pull() {
  BRANCH="$(eval $GIT_BRANCH_NAME)"
  REMOTE="$(git remote)"
  echo "Pulling from branch \e[33m$BRANCH\e[0m on \e[34m$REMOTE\e[0m..."
  eval git fetch --all --prune && git rebase $REMOTE/$BRANCH
}

# Merge local or remote branch on current remote
function mergre() {
  REMOTE="$(git remote)"
  BRANCH="$1"
  if [ -z "$1" ]
  then
    BRANCH="$(git branch -r | fzf | sed -E 's/^[[:space:]]*[A-Za-z0-9]+\///')"
  fi
  echo "Merging branch \e[34m$BRANCH\e[0m on $REMOTE..."
  eval git merge $2 $3 $4 $REMOTE $BRANCH
}

# Rebase onto a local or remote branch on current remote
function rebase() {
  REMOTE="$(git remote)"
  BRANCH="$1"
  if [ -z "$1" ]
  then
    BRANCH="$(git branch -r | fzf | sed -E 's/^[[:space:]]*[A-Za-z0-9]+\///')"
  fi
  echo "Rebasing to \e[34m$BRANCH\e[0m on $REMOTE..."
  eval git pull --rebase $2 $3 $4 $REMOTE $BRANCH
}

# Force push with lease in current branch to current remote
function force() {
  BRANCH="$(eval $GIT_BRANCH_NAME)"
  REMOTE="$(git remote)"
  echo "Are you sure you want to force-push to \e[33m$BRANCH\e[0m? \e[34m(y/\e[32;1mN\e[0m)"
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    eval git push --force-with-lease $REMOTE $BRANCH $@
  fi
}

# Shorthand for git add, commit and push (or finishing your work)
function finish() {
  echo "Git add, commit and push..."
  git add -A
  git commit -m $1 $2 $3 $4
  push $2 $3 $4
}

# Finish, but run tests first
function testfinish() {
  yarn test && finish $@
}

# Finish, but ignore all git hooks
function finish!() {
  echo "Git add, commit and push... (🔥 Ignoring git hooks)"
  git add -A
  git commit -m --no-verify $1 $2 $3 $4
  push! $2 $3 $4
}

# --------------------
# FUNCTIONS / PLUGIN ACCOMODATIONS
# --------------------

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

# --------------------
# PLUGINS / MISC
# --------------------

# nvm - Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# bun completions
[ -s "/Users/denis/.bun/_bun" ] && source "/Users/denis/.bun/_bun"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
