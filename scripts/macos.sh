#!/usr/bin/env bash
set -euo pipefail

echo "⚙️  Setting up macOS preferences..."

# Disable cursor shake (requires logout)
defaults write NSGlobalDomain CGDisableCursorLocationMagnification -bool true
echo "   ✓ Disable cursor shake"

# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
echo "   ✓ Tap to click"

# Enable keyboard navigation between controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
echo "   ✓ Keyboard navigation"

# Always use tabs
defaults write NSGlobalDomain AppleWindowTabbingMode -string 'always'
echo "   ✓ Window tabbing"

# Disable saving login state
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
echo "   ✓ Disable saving login state when logging out"

# Mouse: linear movement (no acceleration)
defaults write -g com.apple.mouse.linear -bool true
echo "   ✓ Linear mouse movement"

# Mouse: tracking speed
defaults write -g com.apple.mouse.scaling -float 1
echo "   ✓ Mouse tracking speed"

echo ""
echo "   ⚠️  Note: 'Disable cursor shake' requires logout to take effect"
