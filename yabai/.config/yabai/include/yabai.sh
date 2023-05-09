#!/usr/bin/env sh

# Ensure we can access the tools we need
export PATH="$PATH:/opt/homebrew/bin"
yabai=$(realpath $(which yabai))
jq=$(realpath $(which jq))

source $(dirname $0)/include/debug.sh
source $(dirname $0)/include/pane.sh
source $(dirname $0)/include/window.sh


