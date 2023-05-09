#!/usr/bin/env sh
set -euxo pipefail

source $(dirname $0)/include/yabai.sh

debug "* Running unmanage.sh *"

# Get focused window data
FW_ID=$(get_focused_window)
FW_STACK_INDEX=$(get_window_stack_index $FW_ID)
debug "Focused window stack index: $FW_STACK_INDEX"
deubg "Focused window ID: $FW_ID"
unmanage_window $FW_ID