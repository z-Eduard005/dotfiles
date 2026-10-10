#!/bin/bash
set -euo pipefail
current=$(gsettings get org.gnome.desktop.interface color-scheme)
THEME=dark

if [[ "$current" == "'prefer-dark'" ]]; then
  THEME=light
else
  THEME=dark
fi

gsettings set org.gnome.desktop.interface color-scheme "prefer-$THEME"
ln -sfn "colors-$THEME.css" "$HOME/dotfiles/accent-styles-css/.config/accent-styles-css/colors/colors-active.css"
ln -sfn "icons-$THEME" "$HOME/dotfiles/waybar/.config/waybar/assets/icons-active"
systemctl --user restart waybar.service
swaync-client --reload-css >/dev/null