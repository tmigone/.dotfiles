#!/usr/bin/env sh
set -euxo pipefail

export PATH="$PATH:/opt/homebrew/bin"

yabai=$(realpath $(which yabai))
jq=$(realpath $(which jq))

debug() {
  if [ "$DEBUG" = "true" ]; then
    echo "$1" >> ~/yabai.log
  fi
}

debug "Running right-pane.sh"

# Get focused window
FW_ID=$(yabai -m query --windows --space | jq ".[] | select(.\"has-focus\") | .id")
debug "Focused window: $FW_ID"

FW_STACK_INDEX=$(yabai -m query --windows --space | jq ".[] | select(.\"has-focus\") | .\"stack-index\"")
debug "Focused window stack index: $FW_STACK_INDEX"

# Get the right pane window at the stack root
# We use the x coordinate to determine if the window is on the right pane, can probably do better here...
SR_ID=$(yabai -m query --windows --space | jq  ".[] | select(.\"is-floating\" == false) | select(.frame.x > 1000) | select(.\"stack-index\" == 0) | .id")
if [ "$SR_ID" = "" ]; then
  debug "No stack root found at stack-index 0, re-trying at stack-index 1"
  SR_ID=$(yabai -m query --windows --space | jq  ".[] | select(.\"is-floating\" == false) | select(.frame.x > 1000) | select(.\"stack-index\" == 1) | .id")
fi
debug "Stack root: $SR_ID"

if [ "$SR_ID" != "" ]; then
  if [ "$FW_ID" != "$SR_ID" ]; then
    if [ "$FW_STACK_INDEX" -eq 0 ]; then
      debug "Stacking $FW_ID to stack root $SR_ID"
      yabai -m window $SR_ID --stack $FW_ID
    fi
  fi
fi

# Ensure that the focused window is not floating
# This puts the window into the default space layout which should be bsp
FW_FLOATING=$(yabai -m query --windows --space | jq ".[] | select(.\"has-focus\") | .\"is-floating\"")
debug "Focused window floating: $FW_FLOATING"

if [ "$FW_FLOATING" = "true" ]; then
  debug "Toggling floating..."
  yabai -m window $FW_ID --toggle float
fi