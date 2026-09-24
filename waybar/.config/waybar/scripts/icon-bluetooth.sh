#!/bin/bash

ICON_DIR="$HOME/.config/waybar/assets/icons"

bluetoothctl show 2>/dev/null | grep -q "Powered: yes" || {
    echo "$ICON_DIR/bluetooth-off.svg"
    exit 0
}

if [ -n "$(bluetoothctl devices Connected 2>/dev/null)" ]; then
    echo "$ICON_DIR/bluetooth-connected.svg"
else
    echo "$ICON_DIR/bluetooth.svg"
fi
