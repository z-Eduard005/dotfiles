#!/bin/bash

PATTERN="HDMI"
STATE="/tmp/hypr_hdmi_cycle_state"

if hyprctl monitors | grep -q "$PATTERN"; then
    n=$(cat "$STATE" 2>/dev/null || echo 0)
    case $n in
        0)
            "$HOME/.config/hypr/scripts/monitor-actions.sh" monitor high
            "$HOME/.config/hypr/scripts/monitor-actions.sh" laptop disable
            echo 1 > "$STATE"
            ;;
        1)
            "$HOME/.config/hypr/scripts/monitor-actions.sh" monitor low
            "$HOME/.config/hypr/scripts/monitor-actions.sh" laptop disable
            echo 2 > "$STATE"
            ;;
        *)
            "$HOME/.config/hypr/scripts/monitor-actions.sh" monitor high
            "$HOME/.config/hypr/scripts/monitor-actions.sh" laptop high
            echo 0 > "$STATE"
            ;;
    esac
else
    "$HOME/.config/hypr/scripts/monitor-actions.sh" laptop high
    echo 0 > "$STATE"
fi