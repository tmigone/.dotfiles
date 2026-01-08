#!/usr/bin/env bash

# Install Command Line Tools
echo "- Checking XCode Command Line Tools installation"
if ! (xcode-select -p 2>/dev/null 1>/dev/null); then
  echo "XCode Command Line Tools not installed. Complete installation and re-run script."
  xcode-select --install
fi

# Apple Silicon support
if [[ $(uname -p) == 'arm' ]]; then
  softwareupdate --install-rosetta
fi

# Set computer name
if [[ -n "$COMPUTER_NAME" ]]; then
  sudo scutil --set ComputerName "$COMPUTER_NAME"
  sudo scutil --set HostName "$COMPUTER_NAME"
  sudo scutil --set LocalHostName "$COMPUTER_NAME"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"
fi

# Create SSH key
if [[ -n "$COMPUTER_NAME" ]] && [[ ! -f ~/.ssh/id_ed25519 ]]; then
  echo "SSH key not present, creating new one..."
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "$COMPUTER_NAME@tmigone.com"
fi

# Install homebrew
if ! command -v brew &>/dev/null; then
  echo "- Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add to PATH for Apple Silicon (needed for rest of script)
  if [[ $(uname -p) == 'arm' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi  
fi
brew update && brew upgrade

# Install brew packages from Brewfile
brew bundle --file brew/Brewfile

# Post brew install
fnm install 24 # Install Node.js 24
corepack enable pnpm # Install pnpm
rustup-init --no-modify-path --default-toolchain stable # Install Rust
open -a $(brew --prefix)/Caskroom/battle-net/[version]/Battle.net-Setup.app

# Cleanup
brew cleanup

# Create some dirs
mkdir -p ~/git/tmigone
mkdir -p ~/git/thegraph

# Npm defaults
npm config set init-author-name "Tomás Migone" --global
npm config set init-author-email "tomasmigone@gmail.com" --global
npm config set init-license "MIT" --global

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# iTerm
# Manually create profile and apply Novel theme colors - TODO: can we use stow for this?

# macOS Dock settings
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 80
defaults write com.apple.dock orientation -string 'left'
defaults write com.apple.dock mineffect -string 'scale'
defaults write NSGlobalDomain AppleWindowTabbingMode -string 'always'
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false

defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/System Preferences.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Calendar.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Spotify.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Discord.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/WhatsApp.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Slack.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Visual Studio Code.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Notion.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
killall Dock

# macOS disable cursor shake
defaults write NSGlobalDomain CGDisableCursorLocationMagnification -bool true

# Gamez
defaults write .GlobalPreferences com.apple.mouse.scaling -1
# Mouse "Tracking speed" > 4/10 ??? 5/10 ?
# Mouse "Scrolling speed" > 4/8
# Keyboard "Key Repeat" > 7/8
# Keyboard "Delay Until Repeat" > 5/6

# 3D printing
git clone --recursive git@github.com:fieldOfView/Cura-OctoPrintPlugin.git "/Users/tomi/Library/Application Support/cura/5.2/plugins/OctoPrintPlugin"
 
# MacBook settings
# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# TODO: Find a way of setting these programatically
## System Preferences
### Keyboard
# - Shortcuts
#   + Keyboard > Move focus to next window: ⌘º
#   + Use keyboard navigation to move focus between controls: Checked
#   + Accessibility > Disable VoiceOver on/off and Show accessibility controls
