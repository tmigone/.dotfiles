#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install node/npm
brew install nvm
nvm install node
nvm use default


# Cleanup
brew cleanup
