#!/usr/bin/env bash

# Install xcode command line tools
echo "- Checking XCode Command Line Tools installation"
if ! (xcode-select -p 2>/dev/null 1>/dev/null); then
  echo "XCode Command Line Tools not installed. Complete installation and re-run script."
  xcode-select --install
fi

# SSH key
if [ ! -f ~/.ssh/id_rsa ]; then
  echo "SSH keys not present, creating new one..."
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" -C "tomasmigone@gmail.com"
fi

# Computer name
COMPUTER_NAME=jarvis
sudo scutil --set ComputerName "$COMPUTER_NAME" && \
sudo scutil --set HostName "$COMPUTER_NAME" && \
sudo scutil --set LocalHostName "$COMPUTER_NAME" && \
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"

# Install homebrew
echo "- Installing Homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update && brew upgrade && brew cleanup

# Install utilities
echo "- Installing command line utilities"
brew install git jq wget htop nmap tree telnet tldr
# Check git being used is homebrew (catalina onwards seems ok)
brew cask install ngrok

# Install programming languages
echo "- Installing programming languages"
brew install python node typescript

# Install CLI tools
echo "- Installing CLI tools"
brew install kubernetes-cli minikube balena-cli now-cli netlify-cli
brew cask install google-cloud-sdk

# Install applications
echo "- Installing applications"
brew cask install google-chrome spotify slack discord visual-studio-code flowdock balenaetcher transmission docker whatsapp battle-net twitch zoomus steam insomnia dbeaver-community vlc fritzing
brew tap homebrew/cask-drivers
brew cask install logitech-control-center

# Install App Store applications
brew install mas
brew lucky "Paint Pad"

# Cleanup
brew cleanup

# npm global packages
npm install -g serve node-gyp eslint mocha ts-node @vue/cli

# Create some dirs
mkdir -p ~/Documents/git/balena
mkdir -p ~/Documents/git/tmigone

# Git defaults
wget -O ~/.gitconfig https://raw.githubusercontent.com/tmigone/dotfiles/master/.gitconfig
wget -O ~/Documents/git/balena/.gitconfig_balena https://raw.githubusercontent.com/tmigone/dotfiles/master/.gitconfig_balena

# Npm defaults
npm config set init-author-name "Tomás Migone" --global
npm config set init-author-email "tomasmigone@gmail.com" --global
npm config set init-license "MIT" --global

# Bash profile
wget -O ~/.bash_profile https://raw.githubusercontent.com/tmigone/dotfiles/master/.bash_profile

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
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Utilities/Terminal.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Spotify.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/WhatsApp.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Slack.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Flowdock.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Discord.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Visual Studio Code.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
killall Dock

# macOS disable cursor shake
defaults write NSGlobalDomain CGDisableCursorLocationMagnification -bool true

# macOS terminal settings
defaults write com.apple.terminal "Default Window Settings" -string "Novel"
defaults write com.apple.terminal "Startup Window Settings" -string "Novel"

# TODO: Find a way of setting these programatically
## System Preferences
### Keyboard
# - Input Sources > Spanish-ISO
# - Shortcuts
#   + Keyboard > Move focus to next window: ⌘º
#   + Full Keyboard Access: All controls
### Terminal
# - Novel > Window > 140x40
