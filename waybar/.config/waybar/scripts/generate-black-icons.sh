#!/bin/bash
# Regenerate assets/icons-black/ from the white set.
set -euo pipefail

SRC="$HOME/dotfiles/waybar/.config/waybar/assets/icons-white"
DST="$HOME/dotfiles/waybar/.config/waybar/assets/icons-black"

[ -d "$SRC" ] || { echo "source missing: $SRC"; exit 1; }
rm -rf "$DST"
cp -r "$SRC" "$DST"
sed -i 's/stroke="#eeeeee"/stroke="#000000"/g' "$DST"/*.svg
echo "OK: $(ls "$DST"/*.svg | wc -l) black icons generated"
