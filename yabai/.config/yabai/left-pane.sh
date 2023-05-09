#!/usr/bin/env sh
set -euxo pipefail

source $(dirname $0)/include/yabai.sh

debug "* Running left-pane.sh *"

# Get focused window data
FW_ID=$(get_focused_window)
FW_STACK_INDEX=$(get_window_stack_index $FW_ID)

# Get the pane roots
LEFT_ROOT_ID=$(get_pane_root "left")
RIGHT_ROOT_ID=$(get_pane_root "right")

# manage_window $FW_ID
debug "Focused window stack index: $FW_STACK_INDEX"
if [ "$FW_STACK_INDEX" -eq "0" ];
  debug "Window"
then
  debug "asdasd"
fi
# Only stack if:
# - The left pane root exists
# - The focused window is not the left pane root
# - The focused window is not already stacked
if [ "$LEFT_ROOT_ID" != "" ] && [ "$FW_ID" != "$LEFT_ROOT_ID" ] && [ "$FW_STACK_INDEX" -eq 0 ]; then
  debug "Stacking window $FW_ID to left pane root $LEFT_ROOT_ID"
  stack_window $LEFT_ROOT_ID $FW_ID
fi