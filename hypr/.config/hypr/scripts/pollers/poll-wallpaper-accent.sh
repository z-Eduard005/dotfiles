#!/bin/bash
MAP="$HOME/.config/wallpaper-accent-map.txt"
STATE="/tmp/hypr-wallpaper-accent"

mapsig() { md5sum "$MAP" 2>/dev/null | cut -d' ' -f1; }

current="$(awww query 2>/dev/null | grep -oP 'image: \K.*' | head -1)"
[ -n "$current" ] || exit 0

[ "$current $(mapsig)" = "$(cat "$STATE" 2>/dev/null)" ] && exit 0

accent="$(dotfiles-get-wallpaper-accent)"
[ -n "$accent" ] && dotfiles-switch-accent "$accent"

# post-run hash is exactly what the next tick must compare against
echo "$current $(mapsig)" > "$STATE"
