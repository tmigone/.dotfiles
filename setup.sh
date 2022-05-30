#!/usr/bin/env bash

# Install xcode command line tools
echo "- Checking XCode Command Line Tools installation"
if ! (xcode-select -p 2>/dev/null 1>/dev/null); then
  echo "XCode Command Line Tools not installed. Complete installation and re-run script."
  xcode-select --install
fi

# Install homebrew
echo "- Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update && brew upgrade && brew cleanup

# Set computer name
COMPUTER_NAME="$1"
sudo scutil --set ComputerName "$COMPUTER_NAME" && \
sudo scutil --set HostName "$COMPUTER_NAME" && \
sudo scutil --set LocalHostName "$COMPUTER_NAME" && \
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"

# Create a new SSH key
if [ ! -f ~/.ssh/id_rsa ]; then
  echo "SSH keys not present, creating new one..."
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" -C "$COMPUTER_NAME@tmigone.com"
fi

# Install utilities
echo "- Installing command line utilities"
brew install git jq wget htop nmap tree telnet tldr
# Check git being used is homebrew (catalina onwards seems ok)
brew install --cask ngrok

# Install programming languages
echo "- Installing programming languages"
brew install python nvm node typescript go solc

# Install CLI tools
echo "- Installing CLI tools"
brew install kubernetes-cli minikube balena-cli now-cli netlify-cli exercism
brew install --cask google-cloud-sdk

# Install applications
echo "- Installing applications"
brew install pygments hadolint bfg solidity truffle
brew install --cask google-chrome spotify slack discord visual-studio-code flowdock balenaetcher transmission docker whatsapp battle-net twitch zoom steam insomnia dbeaver-community vlc fritzing arduino autodesk-fusion360 ultimaker-cura signal daisydisk ganache notion
open -a /usr/local/Caskroom/battle-net/latest/Battle.net-Setup.app
brew tap homebrew/cask-drivers
brew install --cask logitech-g-hub

# Install App Store applications
brew install mas
echo "Sign in to the App store and hit enter..."
read
mas lucky "Paint Pad"

brew install zsh-syntax-highlighting zsh-autosuggestions
brew install --cask iterm2

# Cleanup
brew cleanup

# npm global packages
npm install -g serve node-gyp eslint mocha @vue/cli firebase-tools hardhat-shorthand

# Create some dirs
mkdir -p ~/Documents/git/tmigone
mkdir -p ~/Documents/git/thegraph

# Git defaults
wget -O ~/.gitconfig https://raw.githubusercontent.com/tmigone/dotfiles/master/git/.gitconfig
wget -O ~/Documents/git/balena/.gitconfig_balena https://raw.githubusercontent.com/tmigone/dotfiles/master/git/.gitconfig_balena

# Npm defaults
npm config set init-author-name "Tomás Migone" --global
npm config set init-author-email "tomasmigone@gmail.com" --global
npm config set init-license "MIT" --global

# zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
wget -O ~/.zshrc https://raw.githubusercontent.com/tmigone/dotfiles/master/zsh/.zshrc
wget -O ~/.oh-my-zsh/custom/themes/tomi.zsh-theme https://raw.githubusercontent.com/tmigone/dotfiles/master/oh-my-zsh/tomi.zsh-theme

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
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Flowdock.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Visual Studio Code.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
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
git clone git@github.com:fieldOfView/Cura-OctoPrintPlugin.git /Applications/Ultimaker\ Cura.app/Contents/Resources/plugins/plugins/OctoPrintPlugin
 
# MacBook settings
# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# TODO: Find a way of setting these programatically
## System Preferences
### Keyboard
# - Input Sources > Spanish-ISO
# - Shortcuts
#   + Keyboard > Move focus to next window: ⌘º
#   + Use keyboard navigation to move focus between controls: Checked
#   + Accessibility > Disable VoiceOver on/off and Show accessibility controls
