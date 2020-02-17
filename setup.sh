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
brew install python node

# Install CLI tools
echo "- Installing CLI tools"
brew install kubernetes-cli balena-cli now-cli netlify-cli
brew cask install google-cloud-sdk

# Install applications
echo "- Installing applications"
brew cask install google-chrome spotify slack visual-studio-code flowdock balenaetcher transmission postman docker whatsapp battle-net
brew tap homebrew/cask-drivers
brew cask install logitech-control-center

# Cleanup
brew cleanup

# npm global packages
npm install -g serve eslint @vue/cli

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
killall Dock

# macOS disable cursor shake
defaults write NSGlobalDomain CGDisableCursorLocationMagnification -bool true

# macOS terminal settings
defaults write com.apple.terminal "Default Window Settings" -string "Novel"
defaults write com.apple.terminal "Startup Window Settings" -string "Novel"

