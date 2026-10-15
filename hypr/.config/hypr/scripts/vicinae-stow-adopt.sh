#!/bin/bash
# vicinae-stow-adopt.sh — repair the stowed vicinae settings link.

LIVE="$HOME/.config/vicinae/settings.json"
REPO="$HOME/dotfiles/vicinae/.config/vicinae/settings.json"
[ -f "$REPO" ] || exit 0
[ ! -L "$LIVE" ] || exit 0
[ -f "$LIVE" ] && cat "$LIVE" > "$REPO" 2>/dev/null || true
ln -sfn "$REPO" "$LIVE" 2>/dev/null || true
exit 0
