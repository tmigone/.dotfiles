#!/usr/bin/env bash
set -euo pipefail

echo "📦 Setting up packages..."

# Install homebrew
if ! command -v brew &>/dev/null; then
  echo "   ⏳ Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add to PATH for Apple Silicon (needed for rest of script)
  if [[ $(uname -p) == 'arm' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi
brew update && brew upgrade
echo "   ✓ Homebrew installed"

brew bundle --file "$SCRIPT_DIR/Brewfile"
brew cleanup
echo "   ✓ Brewfile packages installed"

# Post brew install
eval "$(fnm env)"
if ! fnm list 2>/dev/null | grep -q "v24"; then
  echo "   ⏳ Installing Node.js 24..."
  fnm install 24
fi
echo "   ✓ Node.js"

if ! command -v pnpm &>/dev/null; then
  echo "   ⏳ Enabling pnpm..."
  corepack enable pnpm
fi
echo "   ✓ pnpm"

if [[ ! -f ~/.cargo/bin/rustc ]]; then
  echo "   ⏳ Installing Rust..."
  rustup-init -y --no-modify-path --default-toolchain stable
fi
echo "   ✓ Rust"

[[ ! -d "/Applications/Battle.net.app" ]] && open -a "$(brew --prefix)"/Caskroom/battle-net/*/Battle.net-Setup.app 2>/dev/null || true

# oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  echo "   ⏳ Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
echo "   ✓ oh-my-zsh"
