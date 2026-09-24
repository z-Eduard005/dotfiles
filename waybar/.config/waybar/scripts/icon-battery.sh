#!/bin/bash

ICON_DIR="$HOME/.config/waybar/assets/icons"

cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100)
status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")

if { [ "$status" = "Charging" ] || [ "$status" = "Full" ]; } && [ "$cap" -lt 100 ]; then
    echo "$ICON_DIR/battery-charging.svg"
elif [ "$cap" -ge 100 ]; then
    echo "$ICON_DIR/battery-full.svg"
elif [ "$cap" -le 15 ]; then
    echo "$ICON_DIR/battery-warning.svg"
elif [ "$cap" -le 35 ]; then
    echo "$ICON_DIR/battery-low.svg"
elif [ "$cap" -le 70 ]; then
    echo "$ICON_DIR/battery-medium.svg"
else
    echo "$ICON_DIR/battery-full.svg"
fi
