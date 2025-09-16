#!/usr/bin/env zsh

STOW_PACKAGES=('tmux' 'zsh' 'oh-my-zsh' 'git' 'bin' 'karabiner' 'ghostty')

# Ensure no stow conflicts
rm ~/.config/karabiner/karabiner.json

# stow
for i in "${STOW_PACKAGES[@]}"
do
  echo "Stowing package $i"
  stow --restow $i
done

