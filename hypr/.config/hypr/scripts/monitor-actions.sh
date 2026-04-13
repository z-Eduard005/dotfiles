#!/bin/bash

MODE="$1" # laptop | monitor
STATE="$2" # disable | high | low

CONF="$HOME/.config/hypr/modules/monitors/overwrite.conf"

# CONFIGS
LAPTOP_HIGH='monitor=eDP-1,1920x1080@144,-1920x0,1'
LAPTOP_LOW='monitor=eDP-1,1920x1080@60,-1920x0,1'
LAPTOP_DISABLE='monitor=eDP-1,disable'

MONITOR_HIGH='monitor=HDMI-A-1,2560x1440@75,0x0,1'
MONITOR_LOW='monitor=HDMI-A-1,1920x1080@75,0x0,1'
MONITOR_DISABLE='monitor=HDMI-A-1,disable'

case "$MODE:$STATE" in
  laptop:high) NEW_LINE="$LAPTOP_HIGH" ;;
  laptop:low) NEW_LINE="$LAPTOP_LOW" ;;
  laptop:disable) NEW_LINE="$LAPTOP_DISABLE" ;;

  monitor:high) NEW_LINE="$MONITOR_HIGH" ;;
  monitor:low) NEW_LINE="$MONITOR_LOW" ;;
  monitor:disable) NEW_LINE="$MONITOR_DISABLE" ;;

  *)
    echo "Usage: $0 laptop|monitor high|low|disable"
    exit 1
    ;;
esac
TARGET_MONITOR="$(echo "$NEW_LINE" | cut -d= -f2 | cut -d, -f1)"

grep -v "^monitor=$TARGET_MONITOR," "$CONF" > "$CONF.tmp"
echo "$NEW_LINE" >> "$CONF.tmp"
mv "$CONF.tmp" "$CONF"