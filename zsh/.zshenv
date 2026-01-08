# Homebrew - must be first so brew-installed tools are available below
eval "$(/opt/homebrew/bin/brew shellenv)"

# Rust toolchain
. "$HOME/.cargo/env"

# Node version manager
eval "$(fnm env)"

# Custom scripts
export PATH="$HOME/.local/bin:$PATH"

# Default editor for git, crontab, etc.
export EDITOR='nvim'

# Required for GPG signing to work in terminal
export GPG_TTY=$(tty)

# Homebrew configuration
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
