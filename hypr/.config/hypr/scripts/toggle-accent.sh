#!/bin/bash
set -euo pipefail
THEME_DIR="$HOME/dotfiles/accent-styles-css/.config/accent-styles-css"

usage() {
  echo "usage: $(basename "$0") blue|teal|green|yellow|orange|red|pink|purple|slate" >&2
  exit 2
}

[ $# -eq 1 ] || usage
ACCENT="$1"
[ -f "$THEME_DIR/accents/accent-$ACCENT.css" ] || usage

ln -sfn "accent-$ACCENT.css" "$THEME_DIR/accents/accent-active.css"
gsettings set org.gnome.desktop.interface accent-color "$ACCENT"
systemctl --user restart waybar.service
swaync-client --reload-css >/dev/null