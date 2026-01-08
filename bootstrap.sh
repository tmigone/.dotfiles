#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="https://github.com/tmigone/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "🚀 Bootstrapping dotfiles..."

# Install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "   ⏳ Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "   ⚠️  Complete the installation and re-run this script."
  exit 1
fi
echo "   ✓ Xcode Command Line Tools"

# Clone dotfiles repo
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "   ⏳ Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "   ✓ Dotfiles already cloned"
fi

# Done
echo ""
echo "✅ Dotfiles cloned to $DOTFILES_DIR"
echo ""
echo "Next steps:"
echo "  cd $DOTFILES_DIR"
echo "  ./setup.sh          # run full setup"
echo "  ./setup.sh --help   # see available options"
