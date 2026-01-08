# dotfiles

My personal dotfiles and macOS provisioning scripts.

## Quick Start

On a new computer:

```bash
curl -fsSL https://raw.githubusercontent.com/tmigone/.dotfiles/master/bootstrap.sh | bash
cd ~/.dotfiles
./setup.sh
```

## Usage

```bash
./setup.sh              # run full setup
./setup.sh system       # install prerequisites and setup machine
./setup.sh packages     # install packages and apps
./setup.sh dotfiles     # install config files
./setup.sh macos        # configure system preferences
./setup.sh dock         # configure dock appearance and apps
```
