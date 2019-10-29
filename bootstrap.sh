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

brew cask install ngrok

# Cleanup
brew cleanup

# Install node/npm
nvm install node
nvm use default

# npm global packages
npm install -g serve
npm install -g eslint
vue
etc

# Defaults
git config --global user.name "Tomás Migone"
git config --global user.email "tomasmigone@gmail.com"
npm config set init-author-name "Tomás Migone" --global
npm config set init-author-email "tomasmigone@gmail.com" --global
npm config set init-license "MIT" --global
