#!/usr/bin/env bash
set -euo pipefail

echo "📁 Setting up dotfiles..."

BACKUP_DIR="$HOME/.dotfiles.bak/$(date +%Y%m%d-%H%M%S)"

# Backup conflicting files before stowing
backup_conflicts() {
  local pkg="$1"
  local pkg_dir="$SCRIPT_DIR/$pkg"

  while IFS= read -r file; do
    local rel_path="${file#$pkg_dir/}"
    local target="$HOME/$rel_path"

    if [[ -e "$target" ]]; then
      local real_path
      real_path=$(readlink -f "$target" 2>/dev/null || echo "$target")

      # Only backup if not already managed by stow (real path outside dotfiles)
      if [[ "$real_path" != "$SCRIPT_DIR/"* ]]; then
        local backup_path="$BACKUP_DIR/$rel_path"
        mkdir -p "$(dirname "$backup_path")"
        mv "$target" "$backup_path"
        echo "   ⚠️  Backed up: ~/$rel_path"
      fi
    fi
  done < <(find "$pkg_dir" -type f)
}

# Stow packages
packages=(tmux gitmux zsh oh-my-zsh git bin karabiner ghostty npm)
for pkg in "${packages[@]}"; do
  backup_conflicts "$pkg"
  stow --restow --no-folding "$pkg"
  echo "   ✓ $pkg"
done

if [[ -d "$BACKUP_DIR" ]]; then
  echo ""
  echo "   📦 Backups saved to: $BACKUP_DIR"
fi
