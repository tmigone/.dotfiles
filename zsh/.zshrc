# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/tomi/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="tomi"

ZSH_DISABLE_COMPFIX=true

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colorize web-search docker docker-compose gitignore)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='/usr/bin/nano'
else
  export EDITOR='/usr/bin/nano'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ls='ls -GFh'
alias h='history'
alias mkdir='mkdir -p'

alias home='cd ~'
alias dev='cd ~/git/tmigone'
alias bal='cd ~/git/balena'
alias tgp='cd ~/git/thegraph'
alias cl='clear'
alias g='google'
alias gh="open \`git remote -v | grep fetch | awk '{print \$2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//'\`| head -n1"
alias c='cursor --reuse-window --add .'
alias cat='ccat'
alias p='ping 1.1.1.1'

alias t='tmux-sessionizer'
alias tt='tmux-sessionizer $(pwd)'
alias tcfg='nano ~/.tmux.conf'
alias tcat='cat ~/.tmux.conf'
alias tl='tmux list-session'
alias tk='tmux kill-session -t'
alias tks='tmux kill-server'

alias zcat='cat ~/.zshrc'
alias zcfg='nano ~/.zshrc'

alias dotcfg='code ~/.dotfiles'

# Docker
alias docker-stop-all-containers='docker stop $(docker ps -a -q)'
alias docker-clean-containers='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'
alias docker-clean-images='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'
alias docker-clean='(docker-clean-containers || true && docker-clean-images) && docker volume prune --force'

# balena
alias balena-support='BALENARC_DATA_DIRECTORY=~/Documents/git/balena/support balena'

myip () {
  EN0=$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')
  EN1=$(ifconfig en1 | grep inet | grep -v inet6 | awk '{print $2}')
  if [ $EN0 ]; then LOCAL_IP=$EN0; else LOCAL_IP=$EN1; fi
  echo 'Private IP: ' $LOCAL_IP

  PRIVATE_IP=$(curl -s ifconfig.co)
  echo 'Public IP: ' $PRIVATE_IP
}

dockersh () {
  local CONTAINER_ID=$1
  if [[ -z "$CONTAINER_ID" ]]; then
    echo "Usage: $0 CONTAINER_ID"
    return 1
  fi

  # try bash first (debian/ubuntu/fedora)
  docker exec -it "$CONTAINER_ID" /bin/bash

  # if that fails, try ash (alpine)
  if [[ $? -ne 0 ]]; then
    docker exec -it "$CONTAINER_ID" /bin/ash
  fi
}

findport () {
  local PORT=$1

  if [[ -z "$PORT" ]]; then
    echo "Usage: $0 PORT"
    return 1
  fi

  lsof -nP -iTCP -sTCP:LISTEN | grep $1
}

clean_history() {
    local pattern=$1

    # Exit if no pattern is provided
    if [[ -z "$pattern" ]]; then
        echo "Error: No pattern provided."
        return 1
    fi

    # Use sed to delete matching lines in the history file
    LC_CTYPE=C sed -i '' "/$pattern/Id" "$HISTFILE"

    # Reload the history to apply changes
    fc -R "$HISTFILE"
}

nuke_keys() {
  clean_history "MNEMONIC"
  clean_history "SEED"
  clean_history "PRIVATE_KEY"
}

function auditMerge() {
  local BASE_BRANCH=$BASE_BRANCH
  local BRANCH=$1

  git fetch origin $BRANCH
  git checkout $BRANCH

  git checkout $BASE_BRANCH
  git merge $BRANCH --ff-only

  GIT_PAGER= git log origin/$BASE_BRANCH..HEAD --oneline

  # Prompt for confirmation to push
  echo "Do you want to push the changes to origin/$BASE_BRANCH? (y/N): "
  read answer

  # Default to 'no' if input is empty or not 'y'
  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    git push -u origin $BASE_BRANCH
  else
    echo "Push aborted."
  fi
}


# Skip forward/back a word with opt-arrow
bindkey '[C' forward-word
bindkey '[D' backward-word

# Select and execute suggestion with º, right key default is too far
bindkey '`' autosuggest-execute

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$PATH:$HOME/.local/bin"
