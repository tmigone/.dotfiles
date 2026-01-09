#!/usr/bin/env bash
set -euo pipefail

echo "🖥️  Setting up system..."

# Install Command Line Tools
if ! (xcode-select -p 2>/dev/null 1>/dev/null); then
  echo "   ⚠️  XCode Command Line Tools not installed. Complete installation and re-run script."
  xcode-select --install
  exit 1
fi
echo "   ✓ XCode Command Line Tools"

# Apple Silicon support
if [[ $(uname -p) == 'arm' ]] && [[ ! -f /Library/Apple/usr/share/rosetta/rosetta ]]; then
  echo "   ⏳ Installing Rosetta..."
  softwareupdate --install-rosetta --agree-to-license
fi
echo "   ✓ Rosetta"

# Set computer name
if [[ -n "${COMPUTER_NAME:-}" ]] && [[ "$(scutil --get ComputerName)" != "$COMPUTER_NAME" ]]; then
  echo "   ⏳ Setting computer name to $COMPUTER_NAME..."
  sudo scutil --set ComputerName "$COMPUTER_NAME"
  sudo scutil --set HostName "$COMPUTER_NAME"
  sudo scutil --set LocalHostName "$COMPUTER_NAME"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"
fi
echo "   ✓ Computer name"

# Create workspace dirs
mkdir -p ~/git/{tmigone,thegraph}
echo "   ✓ Workspace directories"
