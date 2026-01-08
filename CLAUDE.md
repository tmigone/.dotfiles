# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository for macOS using GNU Stow to symlink configurations into the home directory.

## Commands

```bash
./setup.sh              # run full setup
./setup.sh <module>     # run specific module (system, packages, dotfiles, macos, dock)
./setup.sh --help       # show available options
```

## Architecture

### Setup Scripts

Main entry point is `setup.sh` which sources modular scripts from `scripts/`:

- **system.sh** - Xcode CLI tools, Rosetta, computer name, SSH key, workspace dirs
- **packages.sh** - Homebrew, Brewfile, fnm/Node, pnpm, Rust, oh-my-zsh, try
- **dotfiles.sh** - Stow all config packages
- **macos.sh** - System preferences (cursor shake, tap to click, keyboard nav)
- **dock.sh** - Dock appearance and pinned apps

### Stow Packages

Each directory is a stow package mirroring home directory structure:

- `zsh/.zshrc` → `~/.zshrc`
- `zsh/.zshenv` → `~/.zshenv`
- `git/.gitconfig` → `~/.gitconfig`

Packages: `zsh`, `git`, `tmux`, `gitmux`, `karabiner`, `ghostty`, `bin`, `oh-my-zsh`, `npm`

### Other Files

- `Brewfile` - Homebrew packages and casks (not stowed)
- `bootstrap.sh` - Initial setup script for new machines

### Zsh Configuration

- `.zshenv` - Environment variables, PATH setup (runs for every shell)
- `.zshrc` - Interactive shell config: oh-my-zsh, aliases, functions, keybindings, plugins

## Coding Style (Shell)

- Use `function name() {}` syntax
- Lowercase local variables with `local var="$1"`
- Always quote variables: `"$var"`
- Use `[[ ]]` for tests
- 2-space indentation
- Include usage message for functions with arguments
