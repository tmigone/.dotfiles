#!/usr/bin/env bash
set -euo pipefail

echo "📁 Setting up dotfiles..."

BACKUP_DIR="$HOME/.dotfiles.bak/$(date +%Y%m%d-%H%M%S)"

# Backup conflicting files before stowing
backup_conflicts() {
  local pkg="$1"
  local pkg_dir="$SCRIPT_DIR/../$pkg"

  while IFS= read -r file; do
    local rel_path="${file#$pkg_dir/}"
    local target="$HOME/$rel_path"

    if [[ -e "$target" && ! -L "$target" ]]; then
      local backup_path="$BACKUP_DIR/$rel_path"
      mkdir -p "$(dirname "$backup_path")"
      mv "$target" "$backup_path"
      echo "   ⚠️  Backed up: ~/$rel_path"
    fi
  done < <(find "$pkg_dir" -type f)
}

# Stow packages
packages=(tmux gitmux zsh oh-my-zsh git bin karabiner ghostty npm)
for pkg in "${packages[@]}"; do
  backup_conflicts "$pkg"
  stow --restow "$pkg"
  echo "   ✓ $pkg"
done

if [[ -d "$BACKUP_DIR" ]]; then
  echo ""
  echo "   📦 Backups saved to: $BACKUP_DIR"
fi
