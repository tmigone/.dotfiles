#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install brew based tools
brew install nvm
brew install wget
brew install htop
brew install nmap
brew install tree
brew install telnet
brew install kubernetes-cli
brew install balena-cli
brew install now-cli
brew install netlify-cli

brew cask install ngrok

# Cleanup
brew cleanup

# Install node/npm
nvm install node
nvm use default

# npm global packages
npm install -g serve
npm install -g eslint

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
