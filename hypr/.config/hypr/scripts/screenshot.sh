#!/bin/bash
set -euo pipefail

# Single instance: a second Print press while one is active exits silently.
exec 9>/tmp/screenshot.lock
flock -n 9 || exit 0

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILENAME="$DIR/ss_$(date +%Y-%m-%d_%H-%M-%S).png"

FREEZE_PID=""
cleanup() {
  if [[ -n "$FREEZE_PID" ]]; then
    kill "$FREEZE_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

hyprpicker -r -z >/dev/null 2>&1 &
FREEZE_PID=$!
sleep 0.2

GEOM="$(slurp -d)" || exit 0
[[ -n "$GEOM" ]] || exit 0

grim -g "$GEOM" "$FILENAME"

kill "$FREEZE_PID" 2>/dev/null || true
FREEZE_PID=""

# Release the lock before wl-copy: it forks a background daemon to serve
# the clipboard, and an inherited lock fd would block all future runs.
exec 9>&-

wl-copy --type image/png < "$FILENAME"