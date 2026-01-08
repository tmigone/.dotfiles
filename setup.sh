#!/usr/bin/env bash
set -euo pipefail

# Install Command Line Tools
echo "- Checking XCode Command Line Tools installation"
if ! (xcode-select -p 2>/dev/null 1>/dev/null); then
  echo "XCode Command Line Tools not installed. Complete installation and re-run script."
  xcode-select --install
fi

# Apple Silicon support
if [[ $(uname -p) == 'arm' ]] && [[ ! -f /Library/Apple/usr/share/rosetta/rosetta ]]; then
  softwareupdate --install-rosetta --agree-to-license
fi

# Set computer name
if [[ -n "$COMPUTER_NAME" ]] && [[ "$(scutil --get ComputerName)" != "$COMPUTER_NAME" ]]; then
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
eval "$(fnm env)"
fnm list 2>/dev/null | grep -q "v24" || fnm install 24
command -v pnpm &>/dev/null || corepack enable pnpm
[[ -f ~/.cargo/bin/rustc ]] || rustup-init -y --no-modify-path --default-toolchain stable
[[ ! -d "/Applications/Battle.net.app" ]] && open -a "$(brew --prefix)"/Caskroom/battle-net/*/Battle.net-Setup.app 2>/dev/null || true

# Cleanup
brew cleanup

# Create some dirs
mkdir -p ~/git/{tmigone,thegraph}

# Npm defaults
npm config set init-author-name "Tomás Migone" --global
npm config set init-author-email "tomasmigone@gmail.com" --global
npm config set init-license "MIT" --global

# oh-my-zsh
[[ -d ~/.oh-my-zsh ]] || sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# macOS dock settings
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 80
defaults write com.apple.dock orientation -string 'left'
defaults write com.apple.dock mineffect -string 'scale'
defaults write NSGlobalDomain AppleWindowTabbingMode -string 'always'
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false

# macOS dock elements
dockutil --remove all --no-restart
dockutil --add /System/Applications/System\ Settings.app --no-restart
dockutil --add /System/Applications/Calendar.app
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

# macOS disable cursor shake
defaults write NSGlobalDomain CGDisableCursorLocationMagnification -bool true

# macOS enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# macOS enable keyboard navigation between controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
