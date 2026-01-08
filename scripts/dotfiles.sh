#!/usr/bin/env bash
set -euo pipefail

echo "📁 Setting up dotfiles..."

# Remove potential conflicts
rm -f ~/.config/karabiner/karabiner.json

# Stow packages
packages=(tmux gitmux zsh oh-my-zsh git bin karabiner ghostty npm)
for pkg in "${packages[@]}"; do
  stow --restow "$pkg"
  echo "   ✓ $pkg"
done
