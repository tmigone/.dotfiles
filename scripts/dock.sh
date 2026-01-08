#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Setting up dock..."

# Dock appearance
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 80
defaults write com.apple.dock orientation -string 'left'
defaults write com.apple.dock mineffect -string 'scale'
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false
echo "   ✓ Dock appearance"

# Dock apps
dockutil --remove all --no-restart
dockutil --add /System/Applications/System\ Settings.app --no-restart
dockutil --add /System/Applications/Calendar.app --no-restart
dockutil --add /Applications/Google\ Chrome.app --no-restart
dockutil --add /Applications/Spotify.app --no-restart
dockutil --add /Applications/Discord.app --no-restart
dockutil --add /Applications/Beeper\ Desktop.app --no-restart
dockutil --add /Applications/Slack.app --no-restart
dockutil --add /Applications/Notion.app --no-restart
dockutil --add /Applications/Ghostty.app --no-restart
dockutil --add /Applications/Cursor.app --no-restart
dockutil --add /Applications/ChatGPT.app --no-restart
killall Dock
echo "   ✓ Dock apps"
