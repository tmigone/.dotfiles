# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS, using GNU Stow to symlink configurations into the home directory. Each subdirectory represents a "stow package" that mirrors the home directory structure.

## Commands

### Deploy configurations
```bash
./setup.sh                    # Stow all packages to home directory
```

### Initial macOS setup (new machine)
```bash
./install.sh                  # Full provisioning: Xcode, Homebrew, packages, macOS settings
```

### Add/update Homebrew packages
```bash
brew bundle --file=brew/Brewfile
```

## Architecture

### Stow Package Structure
Each directory is a stow package containing files that mirror their target location in `~`:
- `zsh/.zshrc` → `~/.zshrc`
- `git/.gitconfig` → `~/.gitconfig`
- `tmux/.tmux.conf` → `~/.tmux.conf`
- `karabiner/.config/karabiner/karabiner.json` → `~/.config/karabiner/karabiner.json`

### Key Packages
- **zsh/** - Shell config with oh-my-zsh, aliases, custom functions (`myip`, `dockersh`, `findport`, `killport`, `audit_merge`, `rebase_chain`)
- **git/** - Git config with GPG signing, aliases, and conditional config for The Graph projects (work)
- **tmux/** - Tmux with Catppuccin theme and gitmux integration
- **karabiner/** - Keyboard remapping (Caps Lock → Hyper key, app launchers)
- **bin/** - Custom scripts including `tmux-sessionizer` for project switching
- **brew/** - Brewfile with all Homebrew dependencies

### Theming
Catppuccin color scheme is used across tmux, ghostty, and terminal. The zsh prompt uses a custom theme at `oh-my-zsh/.oh-my-zsh/custom/themes/tomi.zsh-theme`.

### Git Workspaces
Two main git directories are configured:
- `~/git/tmigone` - Personal projects
- `~/git/thegraph` - Work projects (uses different git email/signing key via conditional include)
