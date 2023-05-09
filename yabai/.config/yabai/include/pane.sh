#!/usr/bin/env sh

source $(dirname $0)/include/debug.sh

# Pane selectors
# Use the x coordinate of a window to determine if it is on the left or right pane
# This is not great, but it works for now
LEFT_PANE_FILTER=".frame.x < 100"
RIGHT_PANE_FILTER=".frame.x > 1000"

# Prints the windows on a pane
# Arguments: $pane(left|right)
print_pane() {
  local PANE="${1:-left}"
  local PANE_FILTER="$LEFT_PANE_FILTER"
  if [ "$PANE" = "right" ]; then
    PANE_FILTER="$RIGHT_PANE_FILTER"
  fi
  local WINDOWS=$(yabai -m query --windows --space | jq -r  ".[] | select(.\"is-floating\" == false) | select($PANE_FILTER) | select(.\"stack-index\" >= 0) | [.id,.title,.\"stack-index\"] | join(\", \")")
  echo "$WINDOWS"
}

# Prints the windows on the left pane
print_left_pane() {
  echo "Left Pane:"
  echo "$(print_pane "left")"
}

# Prints the windows on the right pane
print_right_pane() {
  echo "Right Pane:"
  echo "$(print_pane "right")"
}

# Returns the window ID of the lowest stack index window on a given pane
# Arguments: $pane(left|right)
# Note that unstacked windows will have a stack index of 0 whilst stacked windows start at 1
get_pane_root() {
  local PANE="${1:-left}"
  local PANE_FILTER="$LEFT_PANE_FILTER"
  if [ "$PANE" = "right" ]; then
    PANE_FILTER="$RIGHT_PANE_FILTER"
  fi

  debug "Getting stack root window for $PANE pane"
  SR_ID=$(yabai -m query --windows --space | jq  ".[] | select(.\"is-floating\" == false) | select($PANE_FILTER) | select(.\"stack-index\" == 0) | .id")
  
  if [ "$SR_ID" = "" ]; then
    debug "No stack root found at stack-index 0, re-trying at stack-index 1"
    SR_ID=$(yabai -m query --windows --space | jq  ".[] | select(.\"is-floating\" == false) | select($PANE_FILTER) | select(.\"stack-index\" == 1) | .id")
  fi
  debug "Stack root: $SR_ID"
  echo "$SR_ID"
}