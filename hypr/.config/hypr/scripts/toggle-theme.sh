#!/bin/bash
set -euo pipefail
current=$(gsettings get org.gnome.desktop.interface color-scheme)
THEME=dark

if [[ "$current" == "'prefer-dark'" ]]; then
  THEME=light
else
  THEME=dark
fi

# gsettings
gsettings set org.gnome.desktop.interface color-scheme "prefer-$THEME"

# waybar & swaync
ln -sfn "colors-$THEME.css" "$HOME/dotfiles/accent-styles-css/.config/accent-styles-css/colors/colors-active.css"
ln -sfn "icons-$THEME" "$HOME/dotfiles/waybar/.config/waybar/assets/icons-active"
systemctl --user restart waybar.service
swaync-client --reload-css >/dev/null

# nwg-drawer
DRAWER="$HOME/dotfiles/nwg-drawer/.config/nwg-drawer/drawer.css"
D_BG="alpha(#222226, 0.95)"; D_FG="#eeeeee"

if [ "$THEME" = "dark" ]; then
  D_BG="alpha(#222226, 0.95)"; D_FG="#eeeeee"
else
  D_BG="alpha(#ebebed, 0.95)"; D_FG="#2f2f34"
fi
if [ -f "$DRAWER" ]; then
  sed -i "/^window {/,/^}/ s/^\( *background-color: \).*/\1${D_BG};/" "$DRAWER" 2>/dev/null || true
  sed -i "/^label {/,/^}/ s/^\( *color: \).*/\1${D_FG};/" "$DRAWER" 2>/dev/null || true
  grep -qF "background-color: ${D_BG};" "$DRAWER" 2>/dev/null || printf '\nwindow {\n  background-color: %s;\n}\n' "$D_BG" >> "$DRAWER" 2>/dev/null || true
  grep -qF "color: ${D_FG};" "$DRAWER" 2>/dev/null || printf '\nlabel {\n  color: %s;\n}\n' "$D_FG" >> "$DRAWER" 2>/dev/null || true
fi