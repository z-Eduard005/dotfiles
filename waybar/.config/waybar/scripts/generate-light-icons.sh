#!/bin/bash
# Regenerate assets/icons-light/ from the canonical dark-theme set.
# The dark set (assets/icons-dark/) is the ONLY hand-edited source of truth.
# Works from anywhere: all paths are absolute.
set -euo pipefail

SRC="$HOME/dotfiles/waybar/.config/waybar/assets/icons-dark"
DST="$HOME/dotfiles/waybar/.config/waybar/assets/icons-light"

[ -d "$SRC" ] || { echo "source missing: $SRC"; exit 1; }
rm -rf "$DST"
cp -r "$SRC" "$DST"
sed -i 's/stroke="#eeeeee"/stroke="#2f2f34"/g' "$DST"/*.svg
echo "OK: $(ls "$DST"/*.svg | wc -l) light icons generated"
