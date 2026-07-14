# Homebrew - must be first so brew-installed tools are available below
eval "$(/opt/homebrew/bin/brew shellenv)"

# Rust toolchain
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"

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

# OpenSSL configuration
export OPENSSL_DIR=$(brew --prefix openssl@3)
export PKG_CONFIG_PATH="$OPENSSL_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"

# amp
export PATH="$PATH:/Users/tomi/.amp/bin"

# pnpm
export PNPM_HOME="/Users/tomi/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
