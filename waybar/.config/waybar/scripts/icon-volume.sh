#!/bin/bash

ICON_DIR="$HOME/.config/waybar/assets/icons"

sink=$(pactl get-default-sink 2>/dev/null)
{
    read -r mute
    read -r vol
    read -r port
} < <(pactl list sinks 2>/dev/null | awk -v sink="$sink" '
    $1 == "Name:" { if ($2 == sink) found = 1; else if (found) exit; next }
    !found { next }
    $1 == "Mute:" { mute = $2; next }
    $1 == "Volume:" && vol == "" { if (match($0, /[0-9]+%/)) vol = substr($0, RSTART, RLENGTH - 1); next }
    $1 == "Active" && $2 == "Port:" { port = ""; for (i = 3; i <= NF; i++) port = port $i " " }
    END { print mute; print vol; print tolower(port) }
')

[ "$mute" = "yes" ] && {
    echo "$ICON_DIR/volume-x.svg"
    exit 0
}

case "$port" in
    *headphone*) echo "$ICON_DIR/headphones.svg"; exit 0 ;;
    *headset*|*handsfree*|*hfp*|*hsp*|*bluez*) echo "$ICON_DIR/headset.svg"; exit 0 ;;
esac

if [ "${vol:-0}" -le 33 ]; then
    echo "$ICON_DIR/volume.svg"
elif [ "$vol" -le 66 ]; then
    echo "$ICON_DIR/volume-1.svg"
else
    echo "$ICON_DIR/volume-2.svg"
fi
