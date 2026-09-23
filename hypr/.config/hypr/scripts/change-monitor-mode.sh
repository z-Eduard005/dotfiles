#!/bin/bash

STATE="/tmp/hypr_hdmi_cycle_state"

notify_mode() {
  notify-send "Monitor mode changed" "$1"
}

n=$(cat "$STATE" 2>/dev/null || echo 0)
case $n in
    0)
        "$HOME/.config/hypr/scripts/monitor-actions.sh" monitor high laptop disable
        notify_mode "monitor high, laptop disabled"
        echo 1 > "$STATE"
        ;;
    1)
        "$HOME/.config/hypr/scripts/monitor-actions.sh" monitor low laptop disable
        notify_mode "monitor low, laptop disabled"
        echo 2 > "$STATE"
        ;;
    2)
        "$HOME/.config/hypr/scripts/monitor-actions.sh" monitor disable laptop low
        notify_mode "monitor disabled, laptop low"
        echo 3 > "$STATE"
        ;;
    3)
        "$HOME/.config/hypr/scripts/monitor-actions.sh" monitor high laptop high
        notify_mode "monitor high, laptop high"
        echo 0 > "$STATE"
        ;;
    *)
        echo 0 > "$STATE"
        ;;
esac
