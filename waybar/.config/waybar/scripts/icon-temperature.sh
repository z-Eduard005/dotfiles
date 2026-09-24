#!/bin/bash

ICON_DIR="$HOME/.config/waybar/assets/icons"

temp=$(($(cat /sys/class/hwmon/hwmon5/temp3_input 2>/dev/null || echo 0) / 1000))

if [ "$temp" -lt 45 ]; then
    echo "$ICON_DIR/thermometer-snowflake.svg"
elif [ "$temp" -lt 65 ]; then
    echo "$ICON_DIR/thermometer.svg"
else
    echo "$ICON_DIR/thermometer-sun.svg"
fi
