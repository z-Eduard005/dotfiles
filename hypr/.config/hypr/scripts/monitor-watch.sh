#!/bin/bash

EXTERNAL_PATTERN="HDMI"
ENABLE_CMD="$HOME/.config/hypr/scripts/monitor-actions.sh laptop high"
DISABLE_CMD="$HOME/.config/hypr/scripts/monitor-actions.sh laptop disable"

# initial check at startup
if ! hyprctl monitors | grep -qE "$EXTERNAL_PATTERN"; then
    $ENABLE_CMD
else
    $DISABLE_CMD
fi

# listen forever
socat -U - UNIX-CONNECT:"${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | while read -r line; do
    case $line in
        *monitoradded*)
            if hyprctl monitors | grep -qE "$EXTERNAL_PATTERN"; then
                $DISABLE_CMD
            fi
            ;;
        *monitorremoved*)
            if ! hyprctl monitors | grep -qE "$EXTERNAL_PATTERN"; then
                $ENABLE_CMD
            fi
            ;;
    esac
done