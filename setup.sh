#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

available_functions="system packages dotfiles macos dock"

run_script() {
  source "$SCRIPT_DIR/scripts/$1.sh"
}

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
  run_script system
  run_script packages
  run_script dotfiles
  run_script macos
  run_script dock
elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
else
  for func in "$@"; do
    if [[ " $available_functions " =~ " $func " ]]; then
      run_script "$func"
    else
      echo "❌ Unknown function: $func"
      echo "Available: $available_functions"
      exit 1
    fi
  done
fi

echo ""
echo "✅ Done!"
