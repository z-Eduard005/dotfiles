#!/bin/bash

ICON_DIR="$HOME/.config/waybar/assets/icons"

pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | grep -q "yes" && {
    echo "$ICON_DIR/volume-x.svg"
    exit 0
}

port=$(pactl list sinks 2>/dev/null | awk -v sink="$(pactl get-default-sink 2>/dev/null)" '
    $1 == "Name:" && $2 == sink { found = 1 }
    found && $1 == "Active" && $2 == "Port:" { for (i = 3; i <= NF; i++) printf "%s ", $i; exit }
' | tr 'A-Z' 'a-z')

case "$port" in
    *headphone*) echo "$ICON_DIR/headphones.svg"; exit 0 ;;
    *headset*|*handsfree*|*hfp*|*hsp*|*bluez*) echo "$ICON_DIR/headset.svg"; exit 0 ;;
esac

vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oE "[0-9]+%" | head -1 | tr -d "%")

if [ "${vol:-0}" -le 33 ]; then
    echo "$ICON_DIR/volume.svg"
elif [ "$vol" -le 66 ]; then
    echo "$ICON_DIR/volume-1.svg"
else
    echo "$ICON_DIR/volume-2.svg"
fi
