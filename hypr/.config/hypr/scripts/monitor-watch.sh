#!/bin/bash

EXTERNAL_PATTERN="HDMI"
ACTIONS="$HOME/.config/hypr/scripts/monitor-actions.sh"

notify_auto() {
    command -v notify-send >/dev/null 2>&1 && notify-send "Monitor mode changed" "$1"
}

dock() {
    "$ACTIONS" monitor high laptop disable
    notify_auto "monitor high, laptop disabled"
}

undock() {
    "$ACTIONS" monitor disable laptop high
    notify_auto "monitor disabled, laptop high"
}

plugged() {
    local f
    for f in /sys/class/drm/card*-HDMI-*/status; do
        [ -r "$f" ] || continue
        grep -qx "connected" "$f" 2>/dev/null && return 0
    done
    hyprctl monitors 2>/dev/null | grep -qE "$EXTERNAL_PATTERN"
}

if plugged; then
    dock
else
    undock
fi

if plugged; then
    last="yes"
else
    last="no"
fi

while true; do
    sleep 2
    if plugged; then
        current="yes"
    else
        current="no"
    fi
    if [ "$current" != "$last" ]; then
        last="$current"
        if [ "$current" = "yes" ]; then
            dock
        else
            undock
        fi
    fi
done
