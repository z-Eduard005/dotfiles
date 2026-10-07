#!/bin/bash

ICON_DIR="$HOME/.config/waybar/assets/icons"

bluetoothctl show 2>/dev/null | grep -q "Powered: yes" || {
    echo "$ICON_DIR/bluetooth-off.svg"
    echo "Bluetooth off"
    exit 0
}

devices=$(bluetoothctl devices Connected 2>/dev/null | sed 's/^Device [0-9A-F:]* //')

if [ -n "$devices" ]; then
    echo "$ICON_DIR/bluetooth-connected.svg"
    echo "$devices"
else
    echo "$ICON_DIR/bluetooth.svg"
    echo "No connected devices"
fi
