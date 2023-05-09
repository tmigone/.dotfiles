#!/usr/bin/env sh

source $(dirname $0)/include/debug.sh

# Returns the ID of the focused window
get_focused_window() {
  local WINDOW_ID=$(yabai -m query --windows --space | jq ".[] | select(.\"has-focus\") | .id")
  debug "Focused window: $WINDOW_ID"
  echo "$WINDOW_ID"
}

# Returns the stack index of a window
# Arguments: $window_id
get_window_stack_index() {
  local WINDOW_ID="$1"
  local STACK_INDEX=$(yabai -m query --windows --space | jq ".[] | select(.id == $WINDOW_ID) | .\"stack-index\"")
  debug "Window $WINDOW_ID stack index: $STACK_INDEX"
  echo "$STACK_INDEX"
}

# Get the float state for a window
# Arguments: $window_id
get_window_float() {
  local WINDOW_ID="$1"
  local WINDOW_FLOATING=$(yabai -m query --windows --space | jq ".[] | select(.id == $WINDOW_ID) | .\"is-floating\"")
  debug "Window $WINDOW_ID floating: $WINDOW_FLOATING"
  echo "$WINDOW_FLOATING" 
}

# Sets float state for a window
# Arguments: $window_id $float(true|false)
set_window_float () {
  local WINDOW_ID="$1"
  local FLOAT=${2:-true}
  local WINDOW_FLOATING=$(get_window_float "$WINDOW_ID")
  debug "Target floating state: $FLOAT"

  if [ "$WINDOW_FLOATING" != "$FLOAT" ]; then
    debug "Toggling floating state..."
    yabai -m window $WINDOW_ID --toggle float
  fi
}

# Adds window to pane management by disabling floating
# Arguments: $window_id
# Note that this will put the window into the default space layout which should be bsp
manage_window () {
  local WINDOW_ID="$1"
  set_window_float "$WINDOW_ID" false
}

# Removes window from pane management by floating it
# Arguments: $window_id
unmanage_window () {
  local WINDOW_ID="$1"
  set_window_float "$WINDOW_ID" true
}

# Stack a window to a stack root
# Arguments: $stack_root_id $window_id
stack_window() {
  local STACK_ROOT_ID="$1"
  local WINDOW_ID="$2"
  local WINDOW_FLOAT=$(get_window_float "$WINDOW_ID")
  local UNFLOAT=""
  if [ "$WINDOW_FLOAT" = "true" ]; then
    UNFLOAT="--toggle float"
  fi
  debug "Stacking window $WINDOW_ID to stack root $STACK_ROOT_ID, unfloating: $UNFLOAT"
  yabai -m window $WINDOW_ID --stack $STACK_ROOT_ID $UNFLOAT
}
