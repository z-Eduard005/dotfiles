#!/bin/bash

exec 9>/tmp/waybar-signals.lock
flock -n 9 || exit 0

watch_pulse() {
    while true; do
        pactl subscribe 2>/dev/null | grep --line-buffered -i "sink" | while read -r _; do
            pkill -RTMIN+8 waybar 2>/dev/null
        done
        sleep 2
    done
}

watch_net() {
    while true; do
        nmcli monitor 2>/dev/null | while read -r _; do
            pkill -RTMIN+9 waybar 2>/dev/null
        done
        sleep 2
    done
}

watch_bt() {
    while true; do
        sleep infinity | bluetoothctl 2>/dev/null | grep --line-buffered "CHG" | while read -r _; do
            pkill -RTMIN+10 waybar 2>/dev/null
        done
        sleep 2
    done
}

watch_pulse &
watch_net &
watch_bt &

wait
