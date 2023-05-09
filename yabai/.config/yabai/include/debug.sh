#!/usr/bin/env sh

DEBUG="${DEBUG:-false}"
YABAI_PANE_LOG=${YABAI_PANE_LOG:-"$HOME/yabai2.log"}

debug() {
  if [ "$DEBUG" = "true" ]; then
    echo "$1" >> "$YABAI_PANE_LOG"
  fi
}