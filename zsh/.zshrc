# =============================================================================
# oh-my-zsh
# =============================================================================

# Installation path
ZSH="$HOME/.oh-my-zsh"

# Theme (custom theme in ~/.oh-my-zsh/custom/themes/)
ZSH_THEME="tomi"

# Disable insecure directory warnings (common with homebrew)
ZSH_DISABLE_COMPFIX=true

# Plugins - keep lean, too many slow down shell startup
plugins=(git colorize web-search docker docker-compose gitignore)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# zsh
# =============================================================================

# plugin: zsh-autosuggestions - installed via brew
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# plugin: zsh-syntax-highlighting - installed via brew
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# keybinding: opt-arrow to skip words
bindkey '[C' forward-word
bindkey '[D' backward-word

# keybinding: backtick to execute autosuggestion
bindkey '`' autosuggest-execute

# =============================================================================
# Tools
# =============================================================================

# try - quickly test code snippets (https://github.com/tobi/try)
eval "$(~/.local/try.rb init ~/.tries)"

# =============================================================================
# Aliases
# =============================================================================

alias ls='ls -GFh'
alias h='history'
alias mkdir='mkdir -p'

alias dev='cd ~/git/tmigone'
alias tgp='cd ~/git/thegraph'
alias cl='clear'
alias g='google'
alias gh="open \`git remote -v | grep fetch | awk '{print \$2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//'\`| head -n1"
alias c='cursor --reuse-window --add .'
alias cat='ccat'
alias p='ping 1.1.1.1'

alias t='tmux-sessionizer'
alias tt='tmux-sessionizer $(pwd)'
alias tcfg='nvim ~/.tmux.conf'
alias tcat='cat ~/.tmux.conf'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'
alias tks='tmux kill-server'

alias zcat='cat ~/.zshrc'
alias zcfg='nvim ~/.zshrc'

alias dotcfg='cursor ~/.dotfiles'

alias pino='sed -u "s/^[^|]*| //" | pino-pretty'

alias docker-stop-all-containers='docker stop $(docker ps -a -q)'
alias docker-clean-containers='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'
alias docker-clean-images='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'
alias docker-clean='(docker-clean-containers || true && docker-clean-images) && docker volume prune --force'

# =============================================================================
# Functions
# =============================================================================

# Show private and public IP addresses
function myip() {
  local en0=$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')
  local en1=$(ifconfig en1 | grep inet | grep -v inet6 | awk '{print $2}')
  local local_ip="${en0:-$en1}"
  echo "Private IP: $local_ip"

  local public_ip=$(curl -s ifconfig.co)
  echo "Public IP: $public_ip"
}

# Open a shell inside a docker container (tries bash, falls back to ash)
function dockersh() {
  local container_id="$1"
  if [[ -z "$container_id" ]]; then
    echo "Usage: dockersh <container_id>"
    return 1
  fi

  docker exec -it "$container_id" /bin/bash

  if [[ $? -ne 0 ]]; then
    docker exec -it "$container_id" /bin/ash
  fi
}

# Find process listening on a port
function findport() {
  local port="$1"

  if [[ -z "$port" ]]; then
    echo "Usage: findport <port>"
    return 1
  fi

  lsof -nP -iTCP -sTCP:LISTEN | grep ":$port"
}

# Kill process listening on a port
function killport() {
  local port="$1"

  if [[ -z "$port" ]]; then
    echo "Usage: killport <port>"
    return 1
  fi

  local pid=$(lsof -nP -iTCP -sTCP:LISTEN | grep ":$port" | awk '{print $2}' | head -n1)

  if [[ -z "$pid" ]]; then
    echo "No process found listening on port $port"
    return 1
  fi

  echo "Killing process $pid using port $port..."
  kill -9 "$pid"
}

# Remove lines matching a pattern from shell history
function clean_history() {
  local pattern="$1"

  if [[ -z "$pattern" ]]; then
    echo "Usage: clean_history <pattern>"
    return 1
  fi

  LC_CTYPE=C sed -i '' "/$pattern/Id" "$HISTFILE"
  fc -R "$HISTFILE"
}

# Remove crypto keys from shell history
function nuke_keys() {
  clean_history "MNEMONIC"
  clean_history "SEED"
  clean_history "PRIVATE_KEY"
}

# Clone a repo into workspace and optionally open in tmux-sessionizer
# Usage: tclone <repo_url> [workspace]
function tclone() {
  local repo="$1"
  local workspace="$2"

  if [[ -z "$repo" ]]; then
    echo "Usage: tclone <repo_url> [workspace]"
    echo "Workspaces: tmigone, thegraph"
    return 1
  fi

  # Prompt for workspace if not provided
  if [[ -z "$workspace" ]]; then
    echo "Clone to which workspace?"
    select ws in "tmigone" "thegraph"; do
      workspace="$ws"
      break
    done
  fi

  local target_dir="$HOME/git/$workspace"
  if [[ ! -d "$target_dir" ]]; then
    echo "Workspace not found: $target_dir"
    return 1
  fi

  # Extract repo name from URL
  local repo_name=$(basename "$repo" .git)

  echo "Cloning $repo_name into $target_dir..."
  git clone "$repo" "$target_dir/$repo_name"

  if [[ $? -eq 0 ]]; then
    echo "Done! Open in tmux? (Y/n): "
    read -r answer
    if [[ "$answer" != "n" && "$answer" != "N" ]]; then
      tmux-sessionizer "$target_dir/$repo_name"
    fi
  fi
}

# Fast-forward merge an audited branch into base branch
function audit_merge() {
  local base_branch="$1"
  local branch="$2"

  if [[ -z "$base_branch" || -z "$branch" ]]; then
    echo "Usage: audit_merge <base_branch> <branch>"
    return 1
  fi

  git fetch origin "$branch"
  git checkout "$branch"

  git checkout "$base_branch"
  git merge "$branch" --ff-only

  GIT_PAGER= git log "origin/$base_branch..HEAD" --oneline

  echo "Do you want to push the changes to origin/$base_branch? (y/N): "
  read answer

  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    git push -u origin "$base_branch"
  else
    echo "Push aborted."
  fi
}

# Rebase a chain of branches sequentially
function rebase_chain() {
  if [[ "$#" -lt 2 ]]; then
    echo "Usage: rebase_chain <base_branch> <branch1> [branch2 ...]"
    return 1
  fi

  local current_base="$1"
  shift

  for branch in "$@"; do
    echo -e "\n🔁 Rebasing \033[1m$branch\033[0m onto \033[1m$current_base\033[0m"

    git checkout "$branch" || {
      echo "❌ Failed to checkout $branch"
      return 1
    }

    git rebase "$current_base" || {
      echo "❌ Rebase of $branch onto $current_base failed."
      echo "👉 Resolve conflicts, then run: git rebase --continue"
      return 1
    }

    echo -e "\n📜 Commits in $branch since origin/$current_base:"
    GIT_PAGER= git log "origin/$current_base..HEAD" --oneline

    echo -n "✅ Rebase complete. Push $branch to origin? (y/N): "
    read confirm_push
    if [[ "$confirm_push" == "y" || "$confirm_push" == "Y" ]]; then
      git push --force-with-lease origin "$branch" || {
        echo "❌ Failed to push $branch"
        return 1
      }
    else
      echo "🚫 Skipped push for $branch"
    fi

    echo -n "➡️  Continue to next rebase? (Y/n): "
    read confirm_next
    if [[ "$confirm_next" == "n" || "$confirm_next" == "N" ]]; then
      echo "🛑 Aborted at $branch"
      return 0
    fi

    current_base="$branch"
  done

  echo -e "\n🎉 Rebase chain complete."
}
