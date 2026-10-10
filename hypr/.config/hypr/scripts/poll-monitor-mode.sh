#!/bin/bash
EXTERNAL_PATTERN="HDMI"
ACTIONS="$HOME/.config/hypr/scripts/monitor-actions.sh"
STATE="/tmp/hypr-monitor-mode"

notify_auto() {
  command -v notify-send >/dev/null 2>&1 && notify-send "Monitor mode changed" "$1"
}

dock() {
  "$ACTIONS" monitor high laptop disable
  systemctl --user restart waybar.service
  notify_auto "monitor high, laptop disabled"
}

undock() {
  "$ACTIONS" monitor disable laptop high
  systemctl --user restart waybar.service
  notify_auto "monitor disabled, monitor high"
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
  current="yes"
else
  current="no"
fi

# unchanged since last tick -> nothing to do
[ "$current" = "$(cat "$STATE" 2>/dev/null)" ] && exit 0
echo "$current" > "$STATE"

if [ "$current" = "yes" ]; then
  dock
else
  undock
fi
