#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Setup functions
# =============================================================================

setup_system() {
  echo "==> Setting up system..."

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
  if [[ -n "${COMPUTER_NAME:-}" ]] && [[ "$(scutil --get ComputerName)" != "$COMPUTER_NAME" ]]; then
    sudo scutil --set ComputerName "$COMPUTER_NAME"
    sudo scutil --set HostName "$COMPUTER_NAME"
    sudo scutil --set LocalHostName "$COMPUTER_NAME"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"
  fi

  # Create SSH key
  if [[ -n "${COMPUTER_NAME:-}" ]] && [[ ! -f ~/.ssh/id_ed25519 ]]; then
    echo "SSH key not present, creating new one..."
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "$COMPUTER_NAME@tmigone.com"
  fi

  # Create workspace dirs
  mkdir -p ~/git/{tmigone,thegraph}
}

setup_packages() {
  echo "==> Setting up packages..."

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

  # oh-my-zsh
  [[ -d ~/.oh-my-zsh ]] || sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

setup_dotfiles() {
  echo "==> Setting up dotfiles..."

  # Remove potential conflicts
  rm -f ~/.config/karabiner/karabiner.json

  # Stow packages
  local packages=(tmux gitmux zsh oh-my-zsh git bin karabiner ghostty npm)
  for pkg in "${packages[@]}"; do
    echo "- Stowing $pkg"
    stow --restow "$pkg"
  done
}

setup_macos() {
  echo "==> Setting up macOS preferences..."

  # Disable cursor shake (requires logout)
  defaults write NSGlobalDomain CGDisableCursorLocationMagnification -bool true

  # Enable tap to click
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

  # Enable keyboard navigation between controls
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

  # Always use tabs
  defaults write NSGlobalDomain AppleWindowTabbingMode -string 'always'

  echo "Note: 'Disable cursor shake' requires logout to take effect"
}

setup_dock() {
  echo "==> Setting up dock..."

  # Dock appearance
  defaults write com.apple.dock tilesize -int 40
  defaults write com.apple.dock magnification -bool true
  defaults write com.apple.dock largesize -int 80
  defaults write com.apple.dock orientation -string 'left'
  defaults write com.apple.dock mineffect -string 'scale'
  defaults write com.apple.dock minimize-to-application -bool true
  defaults write com.apple.dock show-recents -bool false

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
}

# =============================================================================
# Main
# =============================================================================

available_functions="system packages dotfiles macos dock"

show_help() {
  echo "Usage: ./setup.sh [function...]"
  echo ""
  echo "Available functions:"
  echo "  system    - install prerequisites and setup machine"
  echo "  packages  - install packages and apps"
  echo "  dotfiles  - install config files"
  echo "  macos     - configure system preferences"
  echo "  dock      - configure dock appearance and apps"
  echo ""
  echo "Examples:"
  echo "  ./setup.sh              # run all"
  echo "  ./setup.sh system       # run just system setup"
  echo "  ./setup.sh macos dock   # run macos and dock setup"
}

if [[ $# -eq 0 ]]; then
  # Run all
  setup_system
  setup_packages
  setup_dotfiles
  setup_macos
  setup_dock
elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
else
  # Run specified functions
  for func in "$@"; do
    if [[ " $available_functions " =~ " $func " ]]; then
      "setup_$func"
    else
      echo "Unknown function: $func"
      echo "Available: $available_functions"
      exit 1
    fi
  done
fi

echo "==> Done!"
