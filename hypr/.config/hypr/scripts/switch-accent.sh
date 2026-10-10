#!/bin/bash
set -euo pipefail
THEME_DIR="$HOME/dotfiles/accent-styles-css/.config/accent-styles-css"
HYPR_THEME="$HOME/.config/hypr/modules/theme.d/override.conf"
ACCENTS=(
  blue:#3584e4
  teal:#2190a4
  green:#3a944a
  yellow:#c88800
  orange:#ed5b00
  red:#e62d42
  pink:#d56199
  purple:#9141ac
  slate:#6f8396
)

usage() {
  echo "usage: $(basename "$0") blue|teal|green|yellow|orange|red|pink|purple|slate" >&2
  exit 2
}

[ $# -eq 1 ] || usage
ACCENT="$1"
CSS="$THEME_DIR/accents/accent-$ACCENT.css"
[ -f "$CSS" ] || usage

HEX=""
for a in "${ACCENTS[@]}"; do
  if [ "${a%%:*}" = "$ACCENT" ]; then
    HEX="${a##*:}"
    break
  fi
done

ln -sfn "accent-$ACCENT.css" "$THEME_DIR/accents/accent-active.css"
gsettings set org.gnome.desktop.interface accent-color "$ACCENT"
systemctl --user restart waybar.service
swaync-client --reload-css >/dev/null

border="${HEX#\#}"
if [ -n "$border" ]; then
  printf 'general {\n  col.active_border = rgb(%s)\n}\n' "$border" > "$HYPR_THEME" 2>/dev/null || true
fi
