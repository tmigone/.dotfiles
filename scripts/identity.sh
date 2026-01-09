#!/usr/bin/env bash
set -euo pipefail

echo "🔑 Setting up identity..."

# SSH key
if [[ -n "${COMPUTER_NAME:-}" ]] && [[ ! -f ~/.ssh/id_ed25519 ]]; then
  echo "   ⏳ Creating SSH key..."
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "$COMPUTER_NAME@tmigone.com"
fi
echo "   ✓ SSH key"

# GPG public key
if [[ -f "$SCRIPT_DIR/keys/public-key.asc" ]]; then
  gpg --import "$SCRIPT_DIR/keys/public-key.asc" 2>/dev/null
  echo "   ✓ GPG public key"
fi
