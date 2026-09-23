#!/bin/bash

CONF="$HOME/.config/hypr/modules/monitors.d/overwrite.conf"

LAPTOP_HIGH='monitor=eDP-1,1920x1080@144,-1920x0,1.0,bitdepth,10'
LAPTOP_LOW='monitor=eDP-1,1920x1080@60,-1920x0,1.0,bitdepth,10'
LAPTOP_DISABLE='monitor=eDP-1,disable'

MONITOR_HIGH='monitor=HDMI-A-1,2560x1440@75,0x0,1.0,bitdepth,10'
MONITOR_LOW='monitor=HDMI-A-1,1920x1080@75,0x0,1.0,bitdepth,10'
MONITOR_DISABLE='monitor=HDMI-A-1,disable'

usage() {
    echo "Usage: $0 [laptop|monitor high|low|disable] ..."
    exit 1
}

[ $# -eq 0 ] && usage
[ $(( $# % 2 )) -ne 0 ] && usage

external_available() {
    local f
    for f in /sys/class/drm/card*-HDMI-*/status; do
        [ -r "$f" ] || continue
        grep -qx "connected" "$f" 2>/dev/null && return 0
    done
    hyprctl monitors 2>/dev/null | grep -qE "HDMI"
}

FILTER_ARGS=()
NEW_LINES=""
SKIPPED=""
while [ $# -gt 0 ]; do
    if [ "$1:$2" = "laptop:disable" ] && ! external_available; then
        SKIPPED=1
        shift 2
        continue
    fi
    case "$1:$2" in
        laptop:high) NEW_LINE="$LAPTOP_HIGH" ;;
        laptop:low) NEW_LINE="$LAPTOP_LOW" ;;
        laptop:disable) NEW_LINE="$LAPTOP_DISABLE" ;;
        monitor:high) NEW_LINE="$MONITOR_HIGH" ;;
        monitor:low) NEW_LINE="$MONITOR_LOW" ;;
        monitor:disable) NEW_LINE="$MONITOR_DISABLE" ;;
        *) usage ;;
    esac
    TARGET_MONITOR="$(echo "$NEW_LINE" | cut -d= -f2 | cut -d, -f1)"
    FILTER_ARGS+=(-e "^monitor=$TARGET_MONITOR,")
    NEW_LINES+="$NEW_LINE"$'\n'
    shift 2
done

if [ -z "$NEW_LINES" ]; then
    notify-send "Monitor mode changed" "laptop disable ignored, monitor unplugged"
    exit 0
fi

[ -f "$CONF" ] || touch "$CONF"
grep -v "${FILTER_ARGS[@]}" "$CONF" > "$CONF.tmp"
printf '%s' "$NEW_LINES" >> "$CONF.tmp"
mv "$CONF.tmp" "$CONF"
