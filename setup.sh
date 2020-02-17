#!/usr/bin/env bash

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update && brew upgrade && brew cleanup && brew cask cleanup

# Install Linux tools
brew install jq
brew install wget
brew install htop
brew install nmap
brew install tree
brew install telnet
brew install tldr
brew cask install ngrok

# Install CLI tools
brew install kubernetes-cli
brew install balena-cli
brew install now-cli
brew install netlify-cli
brew cask install google-cloud-sdk

# Install programming language environments
brew install python3
brew install nvm
nvm install node
nvm use default

# Install applications
brew cask install google-chrome
brew cask installspotify 
brew cask installslack
brew cask install visual-studio-code
brew cask install flowdock
brew cask install balenaetcher
brew install transmission

# Cleanup
brew cleanup && brew cask cleanup

# npm global packages
npm install -g serve
npm install -g eslint
npm install -g @vue/cli

# Create some dirs
mkdir -p ~/Documents/git/balena
mkdir -p ~/Documents/git/tmigone

# Git defaults
cp .gitconfig ~/.gitconfig
cp .gitconfig_balena ~/Documents/git/balena/.gitconfig_balena 

# Npm defaults
npm config set init-author-name "Tomás Migone" --global
npm config set init-author-email "tomasmigone@gmail.com" --global
npm config set init-license "MIT" --global
