#!/bin/bash
SCRIPTS="$HOME/.config/hypr/scripts"

while true; do
  sleep 0.5
  "$SCRIPTS/poll-monitor-mode.sh"
  "$SCRIPTS/poll-wallpaper-accent.sh"
  "$SCRIPTS/vicinae-stow-adopt.sh"
done
