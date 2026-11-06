#!/bin/bash
MAP="$HOME/.config/wallpaper-accent-map.txt"
STATE="$HOME/.local/state/dotfiles/hypr/wallpaper-accent"
mkdir -p "$(dirname "$STATE")"

mapsig() { md5sum "$MAP" 2>/dev/null | cut -d' ' -f1; }

current="$(awww query 2>/dev/null | grep -oP 'image: \K.*' | head -1)"
[ -n "$current" ] || exit 0

[ "$current $(mapsig)" = "$(cat "$STATE" 2>/dev/null)" ] && exit 0

accent="$(dotfiles-accent wallpaper-extract)"
[ -n "$accent" ] && dotfiles-accent switch "$accent"

# post-run hash is exactly what the next tick must compare against
echo "$current $(mapsig)" > "$STATE"
